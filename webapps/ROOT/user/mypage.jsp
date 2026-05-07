<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="repo.DataStore" %>
<%@ page import="model.Book" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ include file="../includes/header.jspf" %>

<%
    model.User u = (model.User)session.getAttribute("loginUser");
    String mode = (String)request.getAttribute("mode");
    if (mode == null) mode = request.getParameter("mode");
    if (mode == null) mode = "dashboard";

    Map<String, Object> stats = new HashMap<>();
    stats.put("openDays", 0); stats.put("total", 0); stats.put("rent", 0); stats.put("sell", 0);
    List<Book> likeBooks = Collections.emptyList();
    List<Book> rentBooks = Collections.emptyList();

    if (u != null) {
        try { 
            stats = DataStore.getUserStats(u.getId()); 
            likeBooks = DataStore.getLikedBooks(u.getId());
        } catch(Exception ignore) {}
    }
%>

<style>
/* (기존 스타일 유지) */
.mypage-layout{ max-width:1100px; margin:24px auto 40px; padding:0 16px; display:grid; grid-template-columns:260px 1fr; gap:24px; }
@media (max-width:960px){ .mypage-layout{ grid-template-columns:1fr; } }
.mypage-sidebar{ background:var(--card-bg); border:1px solid var(--border); border-radius:18px; padding:20px 18px; box-shadow:var(--shadow); height:fit-content; }
.mypage-profile-top{ display:flex; align-items:center; gap:12px; margin-bottom:16px; }
.mypage-avatar{ width:56px; height:56px; border-radius:50%; background:linear-gradient(135deg,#6366f1,#a855f7); display:flex; align-items:center; justify-content:center; color:#fff; font-size:22px; font-weight:700; overflow: hidden; position: relative; }
.mypage-avatar img { width: 100%; height: 100%; object-fit: cover; position: absolute; top: 0; left: 0; }
.mypage-profile-main{ flex:1; }
.mypage-profile-name{ margin:0; font-weight:700; color:var(--fg); }
.mypage-profile-meta{ margin:4px 0 0; font-size:12px; color:var(--muted); }
.mypage-nav{ margin-top:16px; display:flex; flex-direction:column; gap:6px; }
.mypage-nav a{ display:flex; align-items:center; gap:10px; padding:8px 12px; border-radius:999px; text-decoration:none; color:var(--fg); font-size:14px; }
.mypage-nav a:hover{ background:rgba(99,102,241,.08); }
.mypage-nav a.is-active{ background:#f4f3ff; color:#111827; font-weight:600; }
.mypage-nav a.is-active span{ color:#4f46e5; }
.mypage-main .section{ margin-bottom:24px; }
.section-header{ display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; }
.section-title{ font-size:22px; font-weight:800; margin:0; color:var(--fg); }
.stat-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px; }
.stat-card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 16px; padding: 20px 16px; text-align: center; box-shadow: var(--shadow); }
.stat-card .label { font-size: 13px; color: var(--muted); margin-bottom: 8px; display: block; }
.stat-card .value { font-size: 20px; font-weight: 800; color: var(--primary); }
.book-list-full { display:flex; flex-direction:column; gap:12px; }
.book-item-row { display:flex; gap:16px; padding:16px; background:var(--card-bg); border:1px solid var(--border); border-radius:12px; align-items:center; }
.book-item-row img { width:80px; height:100px; object-fit:cover; border-radius:6px; background:var(--surface); border:1px solid var(--border); }
.book-item-info { flex:1; }
.book-item-title { font-size:16px; font-weight:700; margin:0 0 6px; }
.book-item-meta { font-size:13px; color:var(--muted); }
.book-item-price { font-weight:700; color:var(--primary); margin-top:4px; }
.book-item-row .btn { height: 36px; padding: 0 16px; display: inline-flex; align-items: center; justify-content: center; font-size: 13px; line-height: 1; white-space: nowrap; box-sizing: border-box; }
.book-item-row form { margin: 0; display: flex; }
.tab-header { display: flex; border-bottom: 1px solid var(--border); margin-bottom: 20px; }
.tab-btn { flex: 1; padding: 14px; background: transparent; border: none; border-bottom: 2px solid transparent; font-size: 15px; font-weight: 600; color: var(--muted); cursor: pointer; transition: 0.2s; }
.tab-btn:hover { color: var(--text); background: var(--surface-2); }
.tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); }
.tab-btn .count { margin-left: 4px; font-size: 12px; background: var(--surface-2); padding: 2px 6px; border-radius: 10px; color: var(--text); }
.tab-content { display: none; animation: fadeIn 0.3s; }
.tab-content.active { display: block; }
.empty-state { padding: 40px; text-align: center; color: var(--muted); background: var(--surface-2); border-radius: 12px; margin-top: 10px; }
.form-group { margin-bottom:16px; }
.form-label { display:block; margin-bottom:6px; font-size:13px; font-weight:600; color:var(--muted); }
.form-input { width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; background:var(--surface); color:var(--fg); }

/* 채팅 스타일 */
.chat-layout { display: grid; grid-template-columns: 320px 1fr; height: 800px; background: var(--card-bg); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; }
.chat-list { border-right: 1px solid var(--border); background: var(--surface); overflow-y: auto; }
.chat-main { display: flex; flex-direction: column; background: var(--card-bg); position: relative; height: 100%; overflow: hidden; }
.chat-item { padding: 18px; border-bottom: 1px solid var(--border); cursor: pointer; transition: .2s; display: flex; gap: 12px; align-items: center; }
.chat-item:hover { background: var(--surface-2); }
.chat-item.active { background: #fff; border-right: 3px solid var(--primary); }
@media (prefers-color-scheme: dark) {
    .chat-item.active { background: rgba(255, 255, 255, 0.08); border-right: 3px solid var(--primary); }
    .chat-item.active .chat-name { color: #fff; }
    .chat-item.active .chat-preview { color: #ccc; }
}
/* [FIX] 아바타 스타일 수정 (포지션 relative/absolute 활용) */
.chat-avatar-wrapper { width: 50px; height: 50px; position: relative; flex-shrink: 0; }
.chat-avatar-initial { width: 100%; height: 100%; border-radius: 50%; background: linear-gradient(135deg, #6366f1, #a855f7); display: flex; align-items: center; justify-content: center; color: #fff; font-weight: bold; font-size: 18px; position: absolute; top: 0; left: 0; }
.chat-avatar-img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; position: absolute; top: 0; left: 0; z-index: 1; }

.chat-info { flex: 1; min-width: 0; }
.chat-name { font-weight: 700; font-size: 15px; color: var(--fg); margin-bottom: 4px; }
.chat-last-msg { font-size: 11px; color: var(--muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; opacity: 0.8; }
.chat-thumb { width: 44px; height: 44px; border-radius: 6px; object-fit: cover; border: 1px solid var(--border); margin-left: 5px; }
.chat-header { padding: 16px 24px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; background: var(--card-bg); }
.chat-header-user { font-size: 18px; font-weight: 800; color: var(--text); }
.chat-header-meta { font-size: 13px; color: var(--muted); margin-left: 8px; font-weight: 400; }
.chat-more-btn { cursor: pointer; color: var(--text); padding: 8px; border-radius: 50%; transition: .2s; }
.chat-more-btn:hover { background: var(--surface-2); }
.more-menu { position: absolute; top: 60px; right: 20px; background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,0.15); display: none; z-index: 100; min-width: 160px; overflow: hidden; }
.more-menu.show { display: block; }
.more-item { display: flex; align-items: center; gap: 8px; width: 100%; padding: 14px 16px; font-size: 14px; color: var(--danger); font-weight: 600; background: none; border: none; cursor: pointer; text-align: left; }
.more-item:hover { background: var(--surface-2); }
.more-item span.icon { font-size: 20px; }
.chat-product-bar { padding: 16px 24px; border-bottom: 1px solid var(--border); background: var(--surface); display: flex; gap: 16px; align-items: center; }
.chat-product-img { width: 64px; height: 64px; border-radius: 8px; object-fit: cover; border: 1px solid var(--border); }
.chat-product-info { flex: 1; }
.product-title { font-weight: 700; font-size: 16px; color: var(--text); margin-bottom: 4px; }
.product-meta { font-size: 13px; color: var(--muted); }
.product-price { font-weight: 800; font-size: 16px; color: var(--primary); margin-top: 4px; }
.chat-messages { flex: 1; overflow-y: auto; padding: 24px; background: #f0f2f5; display: flex; flex-direction: column; gap: 14px; min-height: 0; }
@media (prefers-color-scheme: dark) { .chat-messages { background: #0b132b; } }
.msg-bubble { max-width: 70%; padding: 12px 16px; border-radius: 18px; font-size: 15px; line-height: 1.5; position: relative; word-break: break-word; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }
.msg-time { font-size: 11px; color: var(--muted); margin-top: 6px; margin-left: 4px; }
.msg-row { display: flex; align-items: flex-end; gap: 8px; }
.msg-row.me { justify-content: flex-end; }
.msg-row.me .msg-bubble { background: var(--primary); color: #fff; border-bottom-right-radius: 4px; }
.msg-row.other { justify-content: flex-start; }
.msg-row.other .msg-bubble { background: var(--card-bg); border: 1px solid var(--border); color: var(--text); border-bottom-left-radius: 4px; }
.chat-input-area { padding: 20px 24px; border-top: 1px solid var(--border); background: var(--card-bg); display: flex; gap: 12px; align-items: center; }
.chat-input { flex: 1; padding: 14px 20px; border-radius: 24px; border: 1px solid var(--border); background: var(--surface-2); color: var(--text); outline: none; font-size: 15px; }
.send-btn { background: var(--primary); color: #fff; border: none; width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: .2s; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
.send-btn:hover { transform: scale(1.05); }
.chat-empty-view { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; color: var(--muted); padding: 20px; }
.chat-empty-icon { font-size: 64px; color: #e5e7eb; margin-bottom: 16px; }

@keyframes fadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }
</style>

<div class="mypage-layout">
  <aside class="mypage-sidebar">
    <div class="mypage-profile-top">
      <div class="mypage-avatar">
        <%-- [FIX] 사이드바 프로필: 이미지 있으면 덮어쓰기 --%>
        <div style="width:100%; height:100%; display:flex; align-items:center; justify-content:center;"><%= (u!=null) ? u.getName().substring(0,1) : "U" %></div>
        <% if (u != null && u.getProfileImg() != null && !u.getProfileImg().isEmpty()) { %> 
            <img src="<%=request.getContextPath()%>/assets/upload/<%=u.getProfileImg()%>" onerror="this.style.display='none'"> 
        <% } %>
      </div>
      <div class="mypage-profile-main">
        <p class="mypage-profile-name"><%= (u!=null) ? u.getName() : "Guest" %></p>
        <p class="mypage-profile-meta"><%= (u!=null) ? u.getStudentNo() : "로그인 필요" %></p>
      </div>
    </div>
    <nav class="mypage-nav">
      <a href="<%=request.getContextPath()%>/user/mypage.jsp?mode=dashboard" class="<%= "dashboard".equals(mode) ? "is-active" : "" %>"><span class="material-symbols-outlined">home</span><span>대시보드</span></a>
      <a href="<%=request.getContextPath()%>/books?mine=true" class="<%= "books".equals(mode) ? "is-active" : "" %>"><span class="material-symbols-outlined">menu_book</span><span>내 책 관리</span></a>
      <a href="<%=request.getContextPath()%>/user/mypage.jsp?mode=chat" class="<%= "chat".equals(mode) ? "is-active" : "" %>"><span class="material-symbols-outlined">chat</span><span>미니 톡 관리</span></a>
      <a href="<%=request.getContextPath()%>/user/mypage.jsp?mode=account" class="<%= "account".equals(mode) ? "is-active" : "" %>"><span class="material-symbols-outlined">manage_accounts</span><span>계정 관리</span></a>
      <a href="<%=request.getContextPath()%>/logout" style="margin-top:10px; color:var(--danger);"><span class="material-symbols-outlined">logout</span><span>로그아웃</span></a>
    </nav>
  </aside>

  <main class="mypage-main">
    <% if (u == null) { %>
        <div class="section card" style="text-align:center; padding:40px;">로그인이 필요합니다.</div>
    
    <%-- 🟢 1. 대시보드 --%>
    <% } else if ("dashboard".equals(mode)) { 
         List<Book> dashBooks = null;
         try { dashBooks = DataStore.findByOwner(u.getId()); } catch(Exception e){}
         if(dashBooks == null) dashBooks = Collections.emptyList();
    %>
      <div class="section-header"><h2 class="section-title">대시보드</h2></div>
      
      <div class="stat-grid">
        <div class="stat-card"><span class="label">오픈일</span><span class="value"><%= stats.get("openDays") %>일</span></div>
        <div class="stat-card"><span class="label">총 등록</span><span class="value"><%= stats.get("total") %>권</span></div>
        <div class="stat-card"><span class="label">판매 완료</span><span class="value"><%= stats.get("sell") %>건</span></div>
      </div>

      <div class="section">
        <div class="tab-header">
            <button class="tab-btn" onclick="openTab(event, 'tab-rentals')">대여한 서적 <span class="count"><%= rentBooks.size() %></span></button>
            <button class="tab-btn active" onclick="openTab(event, 'tab-products')">등록한 서적 <span class="count"><%= dashBooks.size() %></span></button>
            <button class="tab-btn" onclick="openTab(event, 'tab-likes')">찜 <span class="count"><%= likeBooks.size() %></span></button>
        </div>
        <div id="tab-rentals" class="tab-content"><div class="empty-state">대여 중인 도서가 없습니다.</div></div>
        <div id="tab-products" class="tab-content active">
            <% if(dashBooks.isEmpty()) { %>
                <div class="empty-state">등록된 책이 없습니다.</div>
            <% } else { %>
                <div class="book-list-full">
                <% int count = 0; for(Book b : dashBooks) { if(count++ >= 5) break; String img = request.getContextPath() + "/assets/img/sample-book.png"; if(b.getBase64Image() != null) img = "data:image/png;base64," + b.getBase64Image(); %>
                   <div class="book-item-row">
                     <img src="<%=img%>">
                     <div class="book-item-info">
                       <div class="book-item-title"><%=b.getTitle()%></div>
                       <div class="book-item-meta"><%=b.getDept()%> · <%=b.getCourse()%></div>
                       <div class="book-item-price"><%=String.format("%,d", b.getPrice())%>원 <small>(<%=b.getTradeType()%>)</small></div>
                     </div>
                     <a href="<%=request.getContextPath()%>/books/detail?id=<%=b.getId()%>" class="btn">상세보기</a>
                   </div>
                <% } %>
                </div>
                <div style="text-align:center; margin-top:12px;"><a href="<%=request.getContextPath()%>/books?mine=true" class="btn ghost">전체보기</a></div>
            <% } %>
        </div>
        <div id="tab-likes" class="tab-content">
            <% if(likeBooks.isEmpty()) { %>
                <div class="empty-state">찜한 상품이 없습니다.</div>
            <% } else { %>
                <div class="book-list-full">
                <% for(Book b : likeBooks) { String img = request.getContextPath() + "/assets/img/sample-book.png"; if(b.getBase64Image() != null) img = "data:image/png;base64," + b.getBase64Image(); %>
                   <div class="book-item-row">
                     <img src="<%=img%>">
                     <div class="book-item-info">
                       <div class="book-item-title"><%=b.getTitle()%></div>
                       <div class="book-item-meta"><%=b.getAuthor()%> | <%=b.getDept()%></div>
                       <div class="book-item-price"><%=String.format("%,d", b.getPrice())%>원 <span class="badge"><%=b.getTradeType()%></span></div>
                     </div>
                     <div style="display:flex; gap:8px; align-items:center;"> 
                         <a href="<%=request.getContextPath()%>/books/detail?id=<%=b.getId()%>" class="btn btn-primary">상세보기</a>
                         <form action="<%=request.getContextPath()%>/books/like" method="post">
                             <input type="hidden" name="bookId" value="<%=b.getId()%>">
                             <button type="submit" class="btn ghost" style="border:1px solid var(--border); color:var(--text);">삭제</button>
                         </form>
                     </div>
                   </div>
                <% } %>
                </div>
            <% } %>
        </div>
      </div>

    <%-- 🟢 2. 내 책 관리 --%>
    <% } else if ("books".equals(mode)) { 
         List<Book> allMyBooks = (List<Book>)request.getAttribute("books");
         if(allMyBooks == null) try { allMyBooks = DataStore.findByOwner(u.getId()); } catch(Exception e){}
    %>
      <div class="section-header"><h2 class="section-title">내 책 관리 (<%= allMyBooks.size() %>권)</h2><a href="<%=request.getContextPath()%>/books/new" class="btn btn-primary">+ 새 책 등록</a></div>
      <div class="book-list-full">
        <% if(allMyBooks.isEmpty()) { %>
            <div class="card" style="padding:40px; text-align:center; color:var(--muted);">등록된 도서가 없습니다.</div>
        <% } else { for(Book b : allMyBooks) { String img = request.getContextPath() + "/assets/img/sample-book.png"; if(b.getBase64Image() != null) img = "data:image/png;base64," + b.getBase64Image(); %>
            <article class="book-item-row">
              <img src="<%=img%>">
              <div class="book-item-info">
                <div class="book-item-title"><%=b.getTitle()%></div>
                <div class="book-item-meta"><%=b.getAuthor()%> | <%=b.getDept()%> | <%=b.getGrade()%>학년<br>등록일: <%= b.getRegDate() %></div>
                <div class="book-item-price"><%=String.format("%,d", b.getPrice())%>원 <span class="badge"><%=b.getTradeType()%></span></div>
              </div>
              <div style="display:flex; gap:8px; align-items:center;">
                  <a href="<%=request.getContextPath()%>/books/detail?id=<%=b.getId()%>" class="btn">보기</a>
                  <form action="<%=request.getContextPath()%>/books/delete" method="post">
                      <input type="hidden" name="id" value="<%=b.getId()%>">
                      <button type="submit" class="btn ghost" style="color:var(--danger); border-color:var(--danger);" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
                  </form>
              </div>
            </article>
        <% } } %>
      </div>

    <%-- 🟢 3. 미니 톡 관리 (채팅) --%>
    <% } else if ("chat".equals(mode)) { 
         List<model.ChatRoom> myRooms = DataStore.getMyChatRooms(u.getId());
         String currentRoomId = request.getParameter("roomId");
         model.ChatRoom curRoom = null;
         if(currentRoomId != null) { for(model.ChatRoom r : myRooms) if(String.valueOf(r.getRoomId()).equals(currentRoomId)) { curRoom = r; break; } }
    %>
      <div class="section-header"><h2 class="section-title">미니 톡 관리</h2></div>
      <div class="chat-layout">
          <div class="chat-list">
              <% if (myRooms.isEmpty()) { %>
                  <div style="padding:40px 20px; text-align:center; color:var(--muted); font-size:13px;">대화 중인 채팅방이 없습니다.</div>
              <% } else { 
                   for(model.ChatRoom r : myRooms) {
                       boolean isActive = String.valueOf(r.getRoomId()).equals(currentRoomId);
                       String bImg = request.getContextPath() + "/assets/img/sample-book.png";
                       if(r.getBookImg() != null) bImg = "data:image/png;base64," + r.getBookImg();
                       
                       String uImg = null;
                       if(r.getOpponentImg() != null && !r.getOpponentImg().trim().isEmpty()) uImg = request.getContextPath() + "/assets/upload/" + r.getOpponentImg();
                       
                       String initial = (r.getOpponentName() != null && r.getOpponentName().length() > 0) ? r.getOpponentName().substring(0, 1) : "?";
                       String lastMsg = (r.getLastMessage() != null) ? r.getLastMessage() : "대화를 시작해보세요!";
                       String lastDate = (r.getLastDate() != null) ? new SimpleDateFormat("MM.dd").format(r.getLastDate()) : "";
              %>
                <div class="chat-item <%= isActive ? "active" : "" %>" onclick="location.href='?mode=chat&roomId=<%=r.getRoomId()%>'">
                    <div class="chat-avatar-wrapper">
                        <div class="chat-avatar-initial"><%= initial %></div>
                        <% if (uImg != null) { %>
                            <img src="<%=uImg%>" class="chat-avatar-img" onerror="this.style.display='none'">
                        <% } %>
                    </div>
                    
                    <div class="chat-text-info">
                        <div class="chat-user-name"><%= r.getOpponentName() %> <span style="font-size:11px; color:var(--muted); font-weight:400; margin-left:4px;"><%= lastDate %></span></div>
                        <div class="chat-last-msg"><%= lastMsg %></div>
                    </div>
                    <img src="<%=bImg%>" class="chat-thumb">
                </div>
              <% } } %>
          </div>

          <div class="chat-main">
              <% if (curRoom == null) { %>
                  <div class="chat-empty-view">
                      <span class="material-symbols-outlined chat-empty-icon">chat_bubble_outline</span>
                      <p class="chat-empty-text">채팅방을 선택해주세요.</p>
                  </div>
              <% } else { 
                   String bImg = request.getContextPath() + "/assets/img/sample-book.png";
                   if(curRoom.getBookImg() != null) bImg = "data:image/png;base64," + curRoom.getBookImg();
              %>
                  <div class="chat-header">
                      <div><span class="chat-header-user"><%= curRoom.getOpponentName() %></span><span class="chat-header-meta">거래 중</span></div>
                      <div style="position:relative;">
                          <span class="material-symbols-outlined chat-more-btn" onclick="toggleMenu()">more_vert</span>
                          <div id="moreMenu" class="more-menu">
                              <form action="<%=request.getContextPath()%>/chat/leave" method="post">
                                  <input type="hidden" name="roomId" value="<%=curRoom.getRoomId()%>">
                                  <button type="submit" class="more-item" onclick="return confirm('나가시겠습니까?')">
                                      <span class="material-symbols-outlined icon">logout</span><span>채팅방 나가기</span>
                                  </button>
                              </form>
                          </div>
                      </div>
                  </div>
                  <div class="chat-product-bar">
                      <img src="<%=bImg%>" class="chat-product-img">
                      <div class="chat-product-info">
                          <div class="product-title"><%= curRoom.getBookTitle() %></div>
                          <div class="product-meta"><%= curRoom.getBookInfo() %></div>
                          <div class="product-price"><%= String.format("%,d", curRoom.getBookPrice()) %>원</div>
                      </div>
                      <button class="btn ghost" style="font-size:12px;" onclick="location.href='<%=request.getContextPath()%>/books/detail?id=<%=curRoom.getBookId()%>'">거래정보확인</button>
                  </div>
                  <div id="msgArea" class="chat-messages"></div>
                  <div class="chat-input-area">
                      <input id="msgInput" class="chat-input" type="text" placeholder="메시지를 입력하세요..." onkeypress="if(event.keyCode==13) sendMsg()">
                      <button onclick="sendMsg()" class="send-btn"><span class="material-symbols-outlined">send</span></button>
                  </div>
                  <script>
                      const roomId = "<%= currentRoomId %>";
                      const myId = "<%= u.getId() %>";
                      const msgArea = document.getElementById('msgArea');
                      function toggleMenu() { document.getElementById('moreMenu').classList.toggle('show'); }
                      window.onclick = function(e) { if (!e.target.matches('.chat-more-btn')) { var m = document.getElementById('moreMenu'); if (m && m.classList.contains('show')) m.classList.remove('show'); } }
                      function sendMsg() {
                          const input = document.getElementById('msgInput');
                          const text = input.value.trim();
                          if(!text) return;
                          fetch('<%=request.getContextPath()%>/chat/send', { method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: 'roomId=' + roomId + '&content=' + encodeURIComponent(text) }).then(() => { input.value = ''; loadMessages(); });
                      }
                      function loadMessages() {
                          fetch('<%=request.getContextPath()%>/chat/load?roomId=' + roomId).then(res => res.json()).then(data => {
                              let html = '';
                              data.forEach(m => {
                                  const isMe = (m.senderId === myId);
                                  html += '<div class="msg-row ' + (isMe ? 'me' : 'other') + '">';
                                  if(isMe) { html += '<span class="msg-time">' + m.date.substring(11, 16) + '</span><div class="msg-bubble">' + m.content + '</div>'; } 
                                  else { html += '<div class="msg-bubble">' + m.content + '</div><span class="msg-time">' + m.date.substring(11, 16) + '</span>'; }
                                  html += '</div>';
                              });
                              const isBottom = (msgArea.scrollHeight - msgArea.scrollTop <= msgArea.clientHeight + 100);
                              msgArea.innerHTML = html;
                              if(isBottom || msgArea.innerHTML === '') msgArea.scrollTop = msgArea.scrollHeight;
                          });
                      }
                      setInterval(loadMessages, 1000);
                      loadMessages();
                  </script>
              <% } %>
          </div>
      </div>

    <%-- 🟢 4. 계정 관리 --%>
    <% } else if ("account".equals(mode)) { %>
      <div class="section-header"><h2 class="section-title">계정 정보 수정</h2></div>
      <div class="card">
        <form action="<%=request.getContextPath()%>/update" method="post" enctype="multipart/form-data">
            <input type="hidden" id="deleteProfileImg" name="deleteProfileImg" value="false">
            <div class="form-group" style="text-align:center; margin-bottom:24px;">
                <div id="previewContainer" class="chat-avatar-wrapper" style="width:100px; height:100px; margin:0 auto 10px; background:#eee; border:1px solid var(--border); border-radius:50%; overflow:hidden;">
                    <% String imgSrc = (u.getProfileImg() != null && !u.getProfileImg().isEmpty()) ? request.getContextPath() + "/assets/upload/" + u.getProfileImg() : ""; %>
                    
                    <div class="chat-avatar-initial" style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; font-size:32px; color:#ccc;"><%= u.getName().substring(0,1) %></div>
                    <% if(!imgSrc.isEmpty()) { %> 
                        <img src="<%=imgSrc%>" style="width:100%; height:100%; object-fit:cover; position:absolute; top:0; left:0; z-index:1;" onerror="this.style.display='none'"> 
                    <% } %>
                </div>
                <div style="display:flex; gap:8px; justify-content:center;">
                    <label for="fileInput" class="btn ghost" style="font-size:12px; padding:4px 10px; cursor:pointer;">사진 변경</label>
                    <button type="button" class="btn ghost" style="font-size:12px; padding:4px 10px; color:var(--danger); border-color:var(--danger); cursor:pointer;" onclick="resetProfileImage()">기본 이미지로</button>
                </div>
                <input id="fileInput" type="file" name="profileImgFile" accept="image/*" style="display:none;" onchange="previewImage(this)">
            </div>
            <div class="form-group"><label class="form-label">아이디 (변경 불가)</label><input class="form-input" value="<%=u.getId()%>" disabled style="background:var(--surface-2); color:var(--muted);"></div>
            <div class="form-group"><label class="form-label">이름</label><input class="form-input" name="name" value="<%=u.getName()%>" required></div>
            <div class="form-group"><label class="form-label">학교</label><input class="form-input" name="school" value="<%= (u.getSchool() != null) ? u.getSchool() : "" %>" placeholder="학교를 입력하세요"></div>
            <div class="form-group"><label class="form-label">학번</label><input class="form-input" name="studentNo" value="<%=u.getStudentNo()%>"></div>
            <div class="form-group"><label class="form-label">비밀번호 변경</label><input type="password" class="form-input" name="pw" placeholder="변경하려면 입력하세요 (비워두면 유지)"></div>
            <div style="text-align:right; margin-top:20px;"><button type="submit" class="btn btn-primary">저장하기</button></div>
        </form>
      </div>
    <% } %>
  </main>
</div>

<script>
function previewImage(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var container = document.getElementById('previewContainer');
            // 미리보기 시에도 이중 레이어 유지
            var initial = container.querySelector('.chat-avatar-initial').outerHTML;
            container.innerHTML = initial + '<img src="' + e.target.result + '" style="width:100%; height:100%; object-fit:cover; position:absolute; top:0; left:0; z-index:1;">';
            document.getElementById('deleteProfileImg').value = 'false';
        };
        reader.readAsDataURL(input.files[0]);
    }
}
function resetProfileImage() {
    var container = document.getElementById('previewContainer');
    // 이미지 제거 (이니셜만 남김)
    var img = container.querySelector('img');
    if(img) img.remove();
    
    document.getElementById('fileInput').value = "";
    document.getElementById('deleteProfileImg').value = "true";
}
function openTab(evt, tabName) {
    var contents = document.getElementsByClassName("tab-content");
    for (var i = 0; i < contents.length; i++) contents[i].classList.remove("active");
    var buttons = document.getElementsByClassName("tab-btn");
    for (var i = 0; i < buttons.length; i++) buttons[i].classList.remove("active");
    document.getElementById(tabName).classList.add("active");
    evt.currentTarget.classList.add("active");
}
</script>

<%@ include file="../includes/footer.jspf" %>