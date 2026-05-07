<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../includes/header.jspf" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>

<style>
.register-card { max-width: 900px; margin: 30px auto; padding: 40px; }
.register-grid { display: grid; grid-template-columns: 300px 1fr; gap: 40px; }
@media (max-width: 800px) { .register-grid { grid-template-columns: 1fr; } }

/* 이미지 업로드 박스 (960:1386 비율 고정) */
.image-upload-box {
  width: 100%; aspect-ratio: 960/1386; 
  background: var(--surface-2);
  border: 2px dashed var(--border); border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  flex-direction: column; cursor: pointer; overflow: hidden; position: relative;
  transition: 0.2s;
}
.image-upload-box:hover { border-color: var(--primary); background: rgba(79,70,229,0.05); }
.image-upload-box img { width: 100%; height: 100%; object-fit: cover; display: none; }
.image-upload-box.has-image img { display: block; }
.image-upload-box.has-image .placeholder { display: none; }
.upload-note { font-size: 13px; color: var(--muted); margin-top: 8px; text-align: center; }

.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }

/* [Modal] 이미지 자르기 팝업 스타일 */
.crop-modal {
  display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0,0,0,0.85); z-index: 9999;
  align-items: center; justify-content: center; padding: 20px;
}
.crop-container {
  background: #fff; width: 100%; max-width: 600px;
  border-radius: 12px; overflow: hidden; display: flex; flex-direction: column;
}
.crop-body {
  height: 400px; background: #333; position: relative;
}
.crop-body img {
  max-width: 100%; max-height: 100%; display: block; 
}
.crop-footer {
  padding: 16px; display: flex; justify-content: space-between; align-items: center;
  background: var(--surface); border-top: 1px solid var(--border);
}
.btn-group { display: flex; gap: 8px; }
</style>

<div class="card register-card">
  <h2 style="margin-bottom: 24px;">서적 등록</h2>
  
  <form action="<%=request.getContextPath()%>/books/new" method="post" enctype="multipart/form-data" id="mainForm" onsubmit="return validatePrice()">
    <div class="register-grid">
      
      <div>
        <label for="bookImgInput" class="image-upload-box" id="dropzone">
          <div class="placeholder" style="text-align: center;">
            <span class="material-symbols-outlined" style="font-size: 48px; color: var(--muted);">crop</span>
            <p style="margin: 8px 0 0; font-weight: 600; color: var(--muted);">사진 추가 및 편집</p>
          </div>
          <img id="preview" src="" alt="Preview">
        </label>
        <input type="file" id="bookImgInput" name="bookImg" accept="image/*" style="display: none;" onchange="startCrop(this)">
        <p class="upload-note">960 x 1386 비율로 자동 편집됩니다.</p>
      </div>

      <div>
        <div class="form-row">
          <div><label class="label">제목</label><input type="text" name="title" required placeholder="책 제목"></div>
          <div><label class="label">저자</label><input type="text" name="author" required placeholder="저자명"></div>
        </div>
        <div class="form-row">
          <div><label class="label">학과</label><input type="text" name="dept" required placeholder="예: 컴퓨터공학과"></div>
          <div><label class="label">과목명</label><input type="text" name="course" required placeholder="관련 과목"></div>
        </div>
        <div class="form-row">
          <div><label class="label">교수명</label><input type="text" name="professor" required placeholder="교수님 성함"></div>
          <div><label class="label">학년</label><input type="text" name="grade" required placeholder="1~4"></div>
        </div>
        <div class="form-row">
          <div>
            <label class="label">거래 유형</label>
            <select name="tradeType" style="width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 10px; background: var(--surface); color: var(--text);">
              <option value="판매중">판매중</option>
              <option value="학기 대여중">학기 대여중</option>
            </select>
          </div>
          <div><label class="label">가격 (원)</label><input type="number" id="priceInput" name="price" required placeholder="0"></div>
        </div>
        
        <div style="margin-bottom: 16px;">
            <label class="label">상태</label>
            <input type="text" name="condition" placeholder="상, 중, 하 (필기 여부 등)">
        </div>
        
        <div style="margin-bottom: 24px;">
            <label class="label">설명</label>
            <textarea name="description" rows="5" placeholder="책 상태에 대한 자세한 설명을 적어주세요." style="width: 100%; padding: 10px; border: 1px solid var(--border); border-radius: 10px; background: var(--surface); color: var(--text);"></textarea>
        </div>

        <div class="actions" style="display: flex; gap: 10px; justify-content: flex-end;">
          <a href="<%=request.getContextPath()%>/books" class="btn ghost">취소</a>
          <button type="submit" class="btn btn-primary" style="padding: 10px 30px;">등록하기</button>
        </div>
      </div>
    </div>
  </form>
</div>

<div class="crop-modal" id="cropModal">
  <div class="crop-container">
    <div class="crop-body">
      <img id="cropImage" src="">
    </div>
    <div class="crop-footer">
      <div class="btn-group">
        <button type="button" class="btn ghost" onclick="rotateImage(-90)">↺ 90도</button>
        <button type="button" class="btn ghost" onclick="rotateImage(90)">↻ 90도</button>
      </div>
      <div class="btn-group">
        <button type="button" class="btn ghost" style="color:var(--danger);" onclick="cancelCrop()">취소</button>
        <button type="button" class="btn btn-primary" onclick="finishCrop()">적용하기</button>
      </div>
    </div>
  </div>
</div>

<script>
// [NEW] 가격 검증 함수
function validatePrice() {
    var priceInput = document.getElementById('priceInput');
    var price = parseFloat(priceInput.value);
    var maxPrice = 2000000000; // 20억

    if (isNaN(price) || price > maxPrice) {
        alert('책의 가격이 너무 높습니다! (최대 20억)');
        priceInput.value = "";
        priceInput.focus();
        return false;
    }
    return true;
}

// Cropper 로직
let cropper;
const bookImgInput = document.getElementById('bookImgInput');
const dropzone = document.getElementById('dropzone');
const preview = document.getElementById('preview');
const cropModal = document.getElementById('cropModal');
const cropImage = document.getElementById('cropImage');

function startCrop(input) {
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = function(e) {
      cropImage.src = e.target.result;
      openModal();
    };
    reader.readAsDataURL(input.files[0]);
  }
}

function openModal() {
  cropModal.style.display = "flex";
  if (cropper) { cropper.destroy(); }
  cropper = new Cropper(cropImage, {
    aspectRatio: 960 / 1386,
    viewMode: 1,
    autoCropArea: 1,
  });
}

function rotateImage(deg) { if (cropper) cropper.rotate(deg); }

function cancelCrop() {
  cropModal.style.display = "none";
  bookImgInput.value = ""; 
  if (cropper) cropper.destroy();
}

function finishCrop() {
  if (!cropper) return;
  const canvas = cropper.getCroppedCanvas({
    width: 960, height: 1386,
    fillColor: '#fff', imageSmoothingEnabled: true, imageSmoothingQuality: 'high',
  });

  canvas.toBlob((blob) => {
    const fileName = "cropped_book_cover.jpg";
    const newFile = new File([blob], fileName, { type: "image/jpeg" });
    const dataTransfer = new DataTransfer();
    dataTransfer.items.add(newFile);
    bookImgInput.files = dataTransfer.files;

    preview.src = URL.createObjectURL(newFile);
    dropzone.classList.add('has-image');
    cropModal.style.display = "none";
    cropper.destroy();
  }, 'image/jpeg', 0.9);
}
</script>

<%@ include file="../includes/footer.jspf" %>