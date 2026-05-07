<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Book" %>
<%@ include file="../includes/header.jspf" %>

<%
    Book b = (Book)request.getAttribute("book");
    String currentImg = request.getContextPath() + "/assets/img/sample-book.png";
    if(b != null && b.getBase64Image() != null) {
        currentImg = "data:image/png;base64," + b.getBase64Image();
    }
%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>

<style>
.register-card { max-width: 900px; margin: 30px auto; padding: 40px; }
.register-grid { display: grid; grid-template-columns: 300px 1fr; gap: 40px; }
@media (max-width: 800px) { .register-grid { grid-template-columns: 1fr; } }
.image-upload-box { width: 100%; aspect-ratio: 960/1386; background: var(--surface-2); border: 2px dashed var(--border); border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-direction: column; cursor: pointer; overflow: hidden; position: relative; transition: 0.2s; }
.image-upload-box:hover { border-color: var(--primary); background: rgba(79,70,229,0.05); }
.image-upload-box img { width: 100%; height: 100%; object-fit: cover; } 
.upload-note { font-size: 13px; color: var(--muted); margin-top: 8px; text-align: center; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
.crop-modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.85); z-index: 9999; align-items: center; justify-content: center; padding: 20px; }
.crop-container { background: #fff; width: 100%; max-width: 600px; border-radius: 12px; overflow: hidden; display: flex; flex-direction: column; }
.crop-body { height: 400px; background: #333; position: relative; }
.crop-body img { max-width: 100%; max-height: 100%; display: block; }
.crop-footer { padding: 16px; display: flex; justify-content: space-between; align-items: center; background: var(--surface); border-top: 1px solid var(--border); }
.btn-group { display: flex; gap: 8px; }
</style>

<div class="card register-card">
  <h2 style="margin-bottom: 24px;">서적 정보 수정</h2>
  <form action="<%=request.getContextPath()%>/books/update" method="post" enctype="multipart/form-data" id="mainForm" onsubmit="return validatePrice()">
    <input type="hidden" name="id" value="<%=b.getId()%>">
    <div class="register-grid">
      <div>
        <label for="bookImgInput" class="image-upload-box" id="dropzone">
          <img id="preview" src="<%=currentImg%>" alt="Preview">
        </label>
        <input type="file" id="bookImgInput" name="bookImg" accept="image/*" style="display: none;" onchange="startCrop(this)">
        <p class="upload-note">이미지를 변경하려면 클릭하세요.</p>
      </div>
      <div>
        <div class="form-row">
          <div><label class="label">제목</label><input type="text" name="title" value="<%=b.getTitle()%>" required></div>
          <div><label class="label">저자</label><input type="text" name="author" value="<%=b.getAuthor()%>" required></div>
        </div>
        <div class="form-row">
          <div><label class="label">학과</label><input type="text" name="dept" value="<%=b.getDept()%>" required></div>
          <div><label class="label">과목명</label><input type="text" name="course" value="<%=b.getCourse()%>" required></div>
        </div>
        <div class="form-row">
          <div><label class="label">교수명</label><input type="text" name="professor" value="<%=b.getProfessor()%>" required></div>
          <div><label class="label">학년</label><input type="text" name="grade" value="<%=b.getGrade()%>" required></div>
        </div>
        <div class="form-row">
          <div>
            <label class="label">거래 유형</label>
            <select name="tradeType" style="width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 10px; background: var(--surface); color: var(--text);">
              <option value="판매중" <%= "판매중".equals(b.getTradeType()) ? "selected" : "" %>>판매중</option>
              <option value="학기 대여중" <%= "학기 대여중".equals(b.getTradeType()) ? "selected" : "" %>>학기 대여중</option>
              <option value="판매완료" <%= "판매완료".equals(b.getTradeType()) ? "selected" : "" %>>판매완료 (Sold Out)</option>
            </select>
          </div>
          <div><label class="label">가격 (원)</label><input type="number" id="priceInput" name="price" value="<%=b.getPrice()%>" required></div>
        </div>
        <div style="margin-bottom: 16px;">
            <label class="label">상태</label>
            <input type="text" name="condition" value="<%=b.getCondition()%>">
        </div>
        <div style="margin-bottom: 24px;">
            <label class="label">설명</label>
            <textarea name="description" rows="5" style="width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 10px; background: var(--surface); color: var(--text);"><%=b.getDescription()%></textarea>
        </div>
        <div class="actions" style="display: flex; gap: 10px; justify-content: flex-end;">
          <a href="<%=request.getContextPath()%>/books/detail?id=<%=b.getId()%>" class="btn ghost">취소</a>
          <button type="submit" class="btn btn-primary" style="padding: 10px 30px;">수정 완료</button>
        </div>
      </div>
    </div>
  </form>
</div>

<div class="crop-modal" id="cropModal">
  <div class="crop-container">
    <div class="crop-body"><img id="cropImage" src=""></div>
    <div class="crop-footer">
      <div class="btn-group"><button type="button" class="btn ghost" onclick="rotateImage(-90)">↺</button><button type="button" class="btn ghost" onclick="rotateImage(90)">↻</button></div>
      <div class="btn-group"><button type="button" class="btn ghost" style="color:var(--danger);" onclick="cancelCrop()">취소</button><button type="button" class="btn btn-primary" onclick="finishCrop()">적용</button></div>
    </div>
  </div>
</div>

<script>
function validatePrice() {
    var priceInput = document.getElementById('priceInput');
    var price = parseFloat(priceInput.value);
    var maxPrice = 2000000000; 
    if (isNaN(price) || price > maxPrice) { alert('책의 가격이 너무 높습니다! (최대 20억)'); priceInput.value = ""; priceInput.focus(); return false; }
    return true;
}
let cropper;
const bookImgInput = document.getElementById('bookImgInput');
const dropzone = document.getElementById('dropzone');
const preview = document.getElementById('preview');
const cropModal = document.getElementById('cropModal');
const cropImage = document.getElementById('cropImage');
function startCrop(input) { if (input.files && input.files[0]) { const reader = new FileReader(); reader.onload = function(e) { cropImage.src = e.target.result; openModal(); }; reader.readAsDataURL(input.files[0]); } }
function openModal() { cropModal.style.display = "flex"; if (cropper) { cropper.destroy(); } cropper = new Cropper(cropImage, { aspectRatio: 960 / 1386, viewMode: 1, autoCropArea: 1 }); }
function rotateImage(deg) { if (cropper) cropper.rotate(deg); }
function cancelCrop() { cropModal.style.display = "none"; bookImgInput.value = ""; if (cropper) cropper.destroy(); }
function finishCrop() { if (!cropper) return; const canvas = cropper.getCroppedCanvas({ width: 960, height: 1386, fillColor: '#fff', imageSmoothingEnabled: true, imageSmoothingQuality: 'high' }); canvas.toBlob((blob) => { const file = new File([blob], "edited.jpg", { type: "image/jpeg" }); const dt = new DataTransfer(); dt.items.add(file); bookImgInput.files = dt.files; preview.src = URL.createObjectURL(file); dropzone.classList.add('has-image'); cropModal.style.display = "none"; cropper.destroy(); }, 'image/jpeg', 0.9); }
</script>
<%@ include file="../includes/footer.jspf" %>