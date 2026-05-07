<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="repo.DataStore" %>
<%@ page import="model.Book" %>
<%@ page import="model.User" %>
<%@ page import="model.Notice" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ include file="includes/header.jspf" %>

<%
    // 배너용 이벤트 목록 가져오기 (랜덤)
    List<Notice> bannerList = DataStore.getBannerEvents();
%>

<style>
/* 공통 변수 */
:root{ --bg:#ffffff; --text:#111827; --muted:#6b7280; --surface:#ffffff; --surface-2:#f3f4f6; --border:#e5e7eb; --primary:#4f46e5; --primary-strong:#4338ca; --danger:#ef4444; }
@media (prefers-color-scheme: dark){ :root{ --bg:#0b132b; --text:#e5e7eb; --muted:#a5acc7; --surface:#1c2541; --surface-2:#0f1b3d; --border:#2a3354; --primary:#8b87ff; --primary-strong:#a5a1ff; --danger:#f87171; } }
body { background: var(--bg); color: var(--text); }
.ubt-home *{ box-sizing: border-box; font-family: 'Noto Sans KR', sans-serif; }
.ubt-home .container{ max-width:1080px; margin:28px auto 40px; padding:0 10px; }
.ubt-home .card{ background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 18px; margin-bottom: 16px; color: var(--text); }
.ubt-home h2, .ubt-home h3{ margin: 0 0 10px; color: var(--text); }

/* 검색창 스타일 */
.ubt-home .searchbar{ display:flex; gap:10px; align-items:center; background: var(--surface-2); border:1px solid var(--border); border-radius: 12px; padding: 10px; }
.ubt-home .searchbar input[type="text"]{ flex:1; border:none; background: transparent; color: var(--text); font-size: 15px; outline: none; }
.ubt-home .searchbar button{ border:1px solid var(--border); background: var(--surface); color: var(--text); border-radius:10px; padding:8px 12px; cursor:pointer; font-weight:600; }
.ubt-home .searchbar button[type="submit"]{ background: var(--primary); color:#fff; border:none; }
.ubt-home .searchbar button[type="submit"]:hover{ background: var(--primary-strong); }
.ubt-home .adv-panel{ margin-top:10px; display:none; background: var(--surface-2); border:1px dashed var(--border); border-radius:12px; padding:12px; }
.ubt-home .adv-panel.show{ display:block; }
.ubt-home .form-row{ display:grid; grid-template-columns: 1fr 1fr; gap:12px; margin-bottom:8px; }
@media (max-width: 720px){ .ubt-home .form-row{ grid-template-columns:1fr; } }
.ubt-home .label{ display:block; font-size:12px; color:var(--muted); margin-bottom:6px; }
.ubt-home .adv-panel input[type="text"]{ width:100%; padding:10px; border-radius:10px; border:1px solid var(--border); background:var(--surface); color:var(--text); }
.ubt-home .small{ margin:6px 0 0; color:var(--muted); font-size:12px; }

/* 슬라이더 배너 스타일 */
.banner-container {
  position: relative;
  width: 100%;
  border-radius: 16px;
  overflow: hidden;
  margin-bottom: 24px;
  box-shadow: var(--shadow);
  background: var(--surface);
  aspect-ratio: 3 / 1; 
}
@media (max-width: 768px) { .banner-container { aspect-ratio: 2 / 1; } }

.banner-wrapper {
  display: flex;
  width: 100%;
  height: 100%;
  transition: transform 0.5s ease-in-out;
}

.banner-item {
  min-width: 100%;
  height: 100%;
  position: relative;
  cursor: pointer;
}

.banner-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

/* 화살표 버튼 */
.slider-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background: rgba(0, 0, 0, 0.3);
  color: white;
  border: none;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10;
  transition: 0.2s;
}
.slider-btn:hover { background: rgba(0, 0, 0, 0.6); }
.prev-btn { left: 16px; }
.next-btn { right: 16px; }

/* 인디케이터 */
.indicators {
  position: absolute; bottom: 12px; left: 50%; transform: translateX(-50%);
  display: flex; gap: 8px; z-index: 10;
}
.indicator {
  width: 8px; height: 8px; border-radius: 50%; background: rgba(255,255,255,0.5);
  cursor: pointer; transition: 0.2s;
}
.indicator.active { background: #fff; transform: scale(1.2); }
</style>

<section class="ubt-home">
  <div class="container">

    <% if (!bannerList.isEmpty()) { %>
    <div class="banner-container" id="bannerContainer">
        
        <div class="banner-wrapper" id="bannerWrapper">
            <% for(int i=0; i<bannerList.size(); i++) { 
                 Notice n = bannerList.get(i);
                 // 이미지 소스 결정 (Base64 우선, 없으면 파일 경로)
                 String imgSrc = "";
                 if (n.getBase64Image() != null) {
                     imgSrc = "data:image/png;base64," + n.getBase64Image();
                 } else if (n.getImgPath() != null) {
                     imgSrc = request.getContextPath() + "/assets/img/" + n.getImgPath();
                 } else {
                     imgSrc = request.getContextPath() + "/assets/img/sample-book.png"; // 기본
                 }
            %>
            <div class="banner-item" onclick="location.href='<%=request.getContextPath()%>/notice/detail.jsp?id=<%=n.getId()%>'">
                <img src="<%=imgSrc%>" alt="<%=n.getTitle()%>">
            </div>
            <% } %>
        </div>

        <% if (bannerList.size() > 1) { %>
            <button class="slider-btn prev-btn" onclick="moveSlide(-1)">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
            </button>
            
            <button class="slider-btn next-btn" onclick="moveSlide(1)">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
            
            <div class="indicators">
                <% for(int i=0; i<bannerList.size(); i++) { %>
                    <div class="indicator <%= (i==0) ? "active" : "" %>" onclick="goToSlide(<%=i%>)"></div>
                <% } %>
            </div>
        <% } %>
        
    </div>
    <% } %>

    <div class="card">
      <h2>전공서적 검색</h2>
      <form action="<%=request.getContextPath()%>/books" method="get" id="searchForm">
        <div class="searchbar">
          <input type="text" name="q" placeholder="제목, 저자, 키워드를 입력하세요" />
          <button type="submit" title="검색">🔍</button>
          <button type="button" class="adv-toggle" id="advBtn" aria-expanded="false">상세검색</button>
        </div>
        <div class="adv-panel" id="advPanel">
          <div class="form-row">
            <div><label class="label">학과</label><input type="text" name="dept" placeholder="예: 소프트웨어융합과"></div>
            <div><label class="label">교수명</label><input type="text" name="prof"></div>
          </div>
          <div class="form-row">
            <div><label class="label">학년</label><input type="text" name="grade" placeholder="예: 1, 2, 3, 4"></div>
            <div><label class="label">과목명</label><input type="text" name="course"></div>
          </div>
          <p class="small">상세조건을 비우면 키워드 검색만 수행됩니다.</p>
        </div>
      </form>
    </div>

    <%
      List<Book> recs = null;
      try { recs = DataStore.getRecommended(); } catch(Exception e) {}
      if (recs == null) recs = Collections.emptyList();
    %>

    <div class="card">
      <h3>추천 서적</h3>
      <% if(recs.isEmpty()) { %>
          <div style="padding:20px; text-align:center; color:var(--muted);">등록된 추천 서적이 없습니다.</div>
      <% } else { %>
      <div class="grid book-grid">
        <%
          long MIN = 60 * 1000; long HOUR = 60 * MIN; long DAY = 24 * HOUR;
          SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");

          for (Book b : recs) {
            String ownerName = "-";
            try {
              if (b.getOwnerId() != null) {
                User u = DataStore.findUser(b.getOwnerId());
                if (u != null) ownerName = u.getName();
              }
            } catch (Exception ignore) {}

            String dept = (b.getDept()!=null)?b.getDept():"";
            String grade = (b.getGrade()!=null)?b.getGrade():"";
            String cond = (b.getCondition()!=null)?b.getCondition():"";

            String timeStr = "방금 전";
            if (b.getRegDate() != null) {
                long diff = System.currentTimeMillis() - b.getRegDate().getTime();
                if (diff < MIN) timeStr = "방금 전";
                else if (diff < HOUR) timeStr = (diff / MIN) + "분 전";
                else if (diff < DAY)  timeStr = (diff / HOUR) + "시간 전";
                else timeStr = (diff / DAY) + "일 전";
            }
            
            String bookImg = request.getContextPath() + "/assets/img/sample-book.png";
            if (b.getBase64Image() != null) bookImg = "data:image/png;base64," + b.getBase64Image();
        %>
          <article class="book-card book-card-list">
            <div class="thumb-wrap"><img src="<%=bookImg%>" alt="book" style="object-fit:cover;"></div>
            <div class="book-body">
              <h3 class="book-title"><a href="<%=request.getContextPath()%>/books/detail?id=<%=b.getId()%>"><%= b.getTitle() %></a></h3>
              <p class="book-price">
                <span class="price-main"><%= String.format("%,d", b.getPrice()) %>원</span>
                <% if (!cond.isEmpty()) { %><span class="price-sub">( <%= cond %> )</span><% } %>
              </p>
              <p class="book-meta"><%= dept %> <% if (!grade.isEmpty()) { %> | <%= grade %>학년 <% } %></p>
            </div>
            <hr class="book-sep">
            <div class="book-footer">
              <span class="owner"><%= ownerName %></span>
              <span class="time"><%= timeStr %></span>
            </div>
          </article>
        <% } %>
      </div>
      <% } %>
    </div>
  </div>
</section>

<script>
// 검색창 토글
(function(){
  const panel = document.getElementById('advPanel');
  const btn = document.getElementById('advBtn');
  if(panel && btn) {
    panel.classList.remove('show');
    btn.addEventListener('click', function(){
      const open = panel.classList.toggle('show');
      btn.textContent = open ? '상세검색 닫기' : '상세검색';
    });
  }
})();

// 슬라이더 로직
let currentIndex = 0;
const slides = document.querySelectorAll('.banner-item');
const totalSlides = slides.length;
const wrapper = document.getElementById('bannerWrapper');
const indicators = document.querySelectorAll('.indicator');
let autoPlayTimer;

function updateSlide() {
    if (totalSlides === 0) return;
    wrapper.style.transform = 'translateX(-' + (currentIndex * 100) + '%)';
    
    indicators.forEach((dot, idx) => {
        dot.classList.toggle('active', idx === currentIndex);
    });
}

function moveSlide(direction) {
    currentIndex += direction;
    if (currentIndex >= totalSlides) currentIndex = 0;
    if (currentIndex < 0) currentIndex = totalSlides - 1;
    updateSlide();
    resetTimer(); 
}

function goToSlide(index) {
    currentIndex = index;
    updateSlide();
    resetTimer();
}

function resetTimer() {
    clearInterval(autoPlayTimer);
    autoPlayTimer = setInterval(() => moveSlide(1), 5000); 
}

if (totalSlides > 1) {
    resetTimer();
}
</script>

<%@ include file="includes/footer.jspf" %>