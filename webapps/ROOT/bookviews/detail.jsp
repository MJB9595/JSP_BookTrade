<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="repo.DataStore" %>
<%@ page import="model.Book" %>
<%@ page import="model.User" %>
<%@ page import="model.Comment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ include file="../includes/header.jspf" %>

<%
  Book book = (Book)request.getAttribute("book");
  if (book == null) {
      String idParam = request.getParameter("id");
      if(idParam != null && !idParam.isEmpty()) {
          try { book = DataStore.findById(Integer.parseInt(idParam)); } catch(Exception e) {}
      }
  }
  if (book == null) {
%>
  <div class="card" style="padding:40px;text-align:center;">
    <h3>존재하지 않는 도서입니다.</h3><br>
    <a href="<%=request.getContextPath()%>/books" class="btn">목록으로</a>
  </div>
<% } else {
     model.User loginUser = (model.User)session.getAttribute("loginUser");
     boolean isMine = (loginUser != null && loginUser.getId().equals(book.getOwnerId()));
     
     // [NEW] 판매완료 여부 체크
     boolean isSoldOut = "판매완료".equals(book.getTradeType());
     
     String ownerName = "알 수 없음"; String ownerDept = "정보 없음";
     try {
         User owner = DataStore.findUser(book.getOwnerId());
         if(owner != null) { ownerName = owner.getName(); ownerDept = "판매자"; }
     } catch(Exception e) {}
     
     String bookImg = request.getContextPath() + "/assets/img/sample-book.png";
     if (book.getBase64Image() != null) bookImg = "data:image/png;base64," + book.getBase64Image();
     
     List<Comment> comments = DataStore.getComments(book.getId());
     SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
     boolean isLiked = (loginUser != null) ? DataStore.isLiked(loginUser.getId(), book.getId()) : false;
%>

<style>
/* 스타일은 기존과 동일 */
:root{ --bg:#ffffff; --text:#111827; --muted:#6b7280; --surface:#ffffff; --surface-2:#f3f4f6; --border:#e5e7eb; --primary:#4f46e5; --primary-strong:#4338ca; --danger:#ef4444; }
@media (prefers-color-scheme: dark){ :root{ --bg:#0b132b; --text:#e5e7eb; --muted:#a5acc7; --surface:#1c2541; --surface-2:#0f1b3d; --border:#2a3354; --primary:#8b87ff; --primary-strong:#a5a1ff; --danger:#f87171; } }
.ubt-detail * { box-sizing: border-box; font-family: 'Noto Sans KR', sans-serif; }
.ubt-detail { color: var(--text); }
.ubt-detail .page { max-width: 1080px; margin: 28px auto 40px; padding: 0 10px; }
.ubt-detail .grid { display:grid; grid-template-columns: 360px 1fr; gap: 28px; align-items:start; }
@media (max-width: 980px){ .ubt-detail .grid { grid-template-columns: 1fr; } }
.ubt-detail .cover-card { background:var(--surface); border:1px solid var(--border); border-radius:16px; padding:24px; }
.ubt-detail .cover { background:var(--surface-2); border-radius:12px; height:420px; display:flex; align-items:center; justify-content:center; overflow: hidden; }
.ubt-detail .cover img { width: 100%; height: 100%; object-fit: contain; border-radius:8px; }
.ubt-detail .btn { width:100%; border:1px solid var(--border); border-radius:12px; padding:12px 14px; font-weight:700; cursor:pointer; background:var(--surface); color:var(--text); }
.ubt-detail .btn + .btn { margin-top:10px; }
.ubt-detail .btn-like { color:var(--muted); }
.ubt-detail .btn-primary { background:var(--primary); color:#fff; border:none; }
.ubt-detail .btn-primary:hover { background:var(--primary-strong); }
.ubt-detail .panel { background:var(--surface); border:1px solid var(--border); border-radius:16px; padding:18px; }
.ubt-detail .title { font-size:28px; font-weight:800; color:var(--text); margin:2px 0 8px; display: flex; align-items: center; gap: 8px; }
.ubt-detail .price { font-size:22px; font-weight:900; color:var(--primary); margin-bottom:10px; }
.ubt-detail .kv { display:grid; grid-template-columns:90px 1fr; column-gap:14px; row-gap:10px; }
.ubt-detail .kv .k { font-weight:700; color:var(--text); }
.ubt-detail .kv .v { color:var(--text); }
.ubt-detail .section-h { font-weight:800; margin:0 0 8px; color:var(--text); }
.ubt-detail .textarea { width:100%; min-height:100px; border:1px solid var(--border); border-radius:12px; padding:12px; font-size:14px; background:var(--surface-2); color:var(--text); resize:vertical; }
.ubt-detail .notice { border:1px solid var(--border); border-radius:16px; background:var(--surface); padding:16px; color:var(--danger); }
.ubt-detail .seller { margin-top:12px; }
.ubt-detail .badge { display:inline-block; font-size:12px; color:var(--primary); background:rgba(79,70,229,.08); border:1px solid rgba(79,70,229,.2); padding:3px 8px; border-radius:999px; }
.ubt-detail .muted { color:var(--muted); }
body { background: var(--bg); color: var(--text); }
.ubt-detail .cover-card .actions{ display: flex; flex-direction: column; gap: 12px; margin-top: 12px; }
.ubt-detail .cover-card .btn{ width: 100%; }

/* 댓글 스타일 */
.comment-list { list-style:none; padding:0; margin:0; display:flex; flex-direction:column; gap:16px; }
.comment-item { border-bottom:1px solid var(--border); padding-bottom:16px; }
.comment-item:last-child { border-bottom:none; padding-bottom:0; }
.comment-head { display:flex; justify-content:space-between; font-size:14px; margin-bottom:4px; align-items:center; }
.comment-writer { font-weight:700; color:var(--text); font-size: 14px; }
.comment-date { color:var(--muted); font-size:12px; margin-left: 6px; }
.comment-body { font-size:14px; line-height:1.5; white-space:pre-wrap; color: var(--text); margin-bottom: 6px; }
.comment-del { color:var(--danger); cursor:pointer; text-decoration:underline; font-size:12px; border:none; background:none; padding:0; }

/* 답글 스타일 */
.reply-item { padding: 10px 10px 10px 20px; background: var(--surface-2); border-radius: 8px; margin-top: 8px; }
.reply-icon { font-weight:bold; color:var(--muted); margin-right: 4px; font-size: 14px; }

/* 로그인 버튼 */
.login-req-btn { display: inline-block; margin-top: 8px; font-size: 14px; font-weight: 700; color: var(--primary); text-decoration: none; padding: 8px 16px; border-radius: 6px; transition: 0.2s; }
.login-req-btn:hover { background: var(--primary); color: #ffffff !important; text-decoration: none; }
</style>

<section class="ubt-detail">
  <div class="page">
    <div class="grid">
      <div class="cover-card">
         <div class="cover"><img src="<%=bookImg%>" alt="book"></div>
         <div class="actions">
            <form action="<%=request.getContextPath()%>/books/like" method="post" style="width:100%; margin-bottom:10px;">
                <input type="hidden" name="bookId" value="<%=book.getId()%>">
                <button type="submit" class="btn <%= isLiked ? "btn-primary" : "btn-like" %>" 
                        style="<%= isLiked ? "background:#ec4899; border-color:#ec4899;" : "" %>" 
                        onclick="<%= (loginUser==null) ? "alert('로그인 후 이용할 수 있습니다.'); location.href='" + request.getContextPath() + "/login'; return false;" : "" %>">
                    <%= isLiked ? "♥ 찜 취소" : "♡ 찜하기" %>
                </button>
            </form>

            <% if (isMine) { %>
                <div style="display:flex; gap:10px; width:100%;">
                    <a href="<%=request.getContextPath()%>/books/edit?id=<%=book.getId()%>" class="btn" style="flex:1; text-align:center; border:1px solid var(--primary); color:var(--primary); background:#fff; line-height:20px; text-decoration:none;">수정</a>
                    <form action="<%=request.getContextPath()%>/books/delete" method="post" style="flex:1; margin:0;">
                        <input type="hidden" name="id" value="<%=book.getId()%>">
                        <button type="submit" class="btn" style="width:100%; background:var(--danger); color:#fff; border:none;" onclick="return confirm('정말 삭제하시겠습니까? 복구할 수 없습니다.');">삭제</button>
                    </form>
                </div>
            <% } else { %>
                <% if (isSoldOut) { %>
                    <button type="button" class="btn" disabled style="background:var(--surface-2); color:var(--muted); border:1px solid var(--border); cursor:not-allowed;">
                        이 책은 이미 팔렸나봐요..
                    </button>
                <% } else { %>
                    <a class="btn btn-primary" 
                       href="<%=request.getContextPath()%>/chat/start?bookId=<%=book.getId()%>" 
                       style="display: flex; align-items: center; justify-content: center; gap: 6px;">
                       <span>미니톡 시작하기</span>
                    </a>
                <% } %>
            <% } %>
         </div>
         
         <div class="panel seller">
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:6px"><strong>판매자 정보</strong><span class="badge">Verified</span></div>
            <div class="kv"><div class="k">닉네임</div><div class="v"><%= ownerName %></div><div class="k">정보</div><div class="v"><%= ownerDept %></div></div>
         </div>
      </div>

      <div>
        <div class="title">
            <%=book.getTitle()%>
            <% if (isSoldOut) { %>
                <span style="font-size:0.5em; color:var(--danger); font-weight:600; margin-left:4px; vertical-align:middle;">(판매완료)</span>
            <% } %>
        </div>
        
        <div class="price"><%=String.format("%,d", book.getPrice())%>원</div>
        
        <div class="kv" style="margin: 10px 0 18px;">
          <div class="k">학과</div><div class="v"><%= (book.getDept()!=null ? book.getDept() : "-") %></div>
          <div class="k">과목명</div><div class="v"><%= (book.getCourse()!=null ? book.getCourse() : "-") %></div>
          <div class="k">교수님</div><div class="v"><%= (book.getProfessor()!=null ? book.getProfessor() : "-") %></div>
          <div class="k">상태</div><div class="v"><%= (book.getCondition()!=null ? book.getCondition() : "-") %></div>
        </div>
        <div class="panel" style="margin-bottom:16px;">
          <div class="section-h">설명</div>
          <p class="muted" style="margin:0; white-space: pre-wrap;"><%= (book.getDescription()!=null ? book.getDescription() : "상세 설명이 없습니다.") %></p>
        </div>

        <div class="panel" style="margin-bottom:16px;">
          <div class="section-h">댓글 (<%= comments.size() %>)</div>
          
          <% if (comments.isEmpty()) { %>
              <div style="text-align:center; padding:20px; color:var(--muted); font-size:13px;">첫 번째 댓글을 남겨보세요!</div>
          <% } else { %>
              <ul class="comment-list">
              <% for (Comment c : comments) { %>
                  <li class="comment-item">
                      <div class="comment-head">
                          <div style="display:flex; align-items:center;">
                              <span class="comment-writer"><%= c.getWriterName() %></span>
                              <span class="comment-date"> · <%= sdf.format(c.getRegDate()) %></span>
                          </div>
                          <% if (loginUser != null && loginUser.getId().equals(c.getWriterId())) { %>
                              <form action="<%=request.getContextPath()%>/books/deleteComment" method="post" style="display:inline;">
                                  <input type="hidden" name="commentId" value="<%=c.getId()%>"><input type="hidden" name="bookId" value="<%=book.getId()%>">
                                  <button type="submit" class="comment-del" onclick="return confirm('삭제하시겠습니까?');">삭제</button>
                              </form>
                          <% } %>
                      </div>
                      <div class="comment-body"><%= c.getContent() %></div>
                      
                      <% if(loginUser != null) { %>
                          <div style="text-align:right;">
                              <button type="button" class="btn btn-primary" style="font-size:12px; padding:4px 10px; width:auto; display:inline-block;" onclick="toggleReplyForm(<%=c.getId()%>)">답글달기</button>
                          </div>
                      <% } %>
                      
                      <div id="reply-form-<%=c.getId()%>" style="display:none; margin-top:10px;">
                          <form action="<%=request.getContextPath()%>/books/comment" method="post">
                              <input type="hidden" name="bookId" value="<%=book.getId()%>">
                              <input type="hidden" name="parentId" value="<%=c.getId()%>">
                              <textarea name="content" placeholder="답글을 입력하세요..." required style="width:100%; min-height:60px; padding:10px; border:1px solid var(--border); border-radius:8px; background:var(--surface); color:var(--text); resize:none; font-size:14px;"></textarea>
                              <div style="text-align:right; margin-top:6px;">
                                  <button type="submit" class="btn btn-primary" style="padding:6px 12px; width:auto; font-size:12px;">등록</button>
                              </div>
                          </form>
                      </div>
                      
                      <% for(Comment reply : c.getReplies()) { %>
                          <div class="reply-item">
                              <div class="comment-head">
                                  <div style="display:flex; align-items:center;">
                                      <span class="reply-icon">&#8627;</span> 
                                      <span class="comment-writer"><%= reply.getWriterName() %></span>
                                      <span class="comment-date"> · <%= sdf.format(reply.getRegDate()) %></span>
                                  </div>
                                  <% if (loginUser != null && loginUser.getId().equals(reply.getWriterId())) { %>
                                      <form action="<%=request.getContextPath()%>/books/deleteComment" method="post" style="display:inline;">
                                          <input type="hidden" name="commentId" value="<%=reply.getId()%>"><input type="hidden" name="bookId" value="<%=book.getId()%>">
                                          <button type="submit" class="comment-del" onclick="return confirm('삭제하시겠습니까?');">x</button>
                                      </form>
                                  <% } %>
                              </div>
                              <div class="comment-body" style="padding-left:16px;"><%= reply.getContent() %></div>
                          </div>
                      <% } %>
                  </li>
              <% } %>
              </ul>
          <% } %>

          <div style="margin-top:20px; border-top:1px solid var(--border); padding-top:16px;">
            <% if (loginUser != null) { %>
                <form action="<%=request.getContextPath()%>/books/comment" method="post">
                    <input type="hidden" name="bookId" value="<%=book.getId()%>">
                    <textarea class="textarea" name="content" placeholder="궁금한 점을 남겨주세요." required></textarea>
                    <div style="text-align:right; margin-top:8px;">
                        <button type="submit" class="btn btn-primary" style="width:auto; padding:8px 16px; font-size:14px;">등록</button>
                    </div>
                </form>
            <% } else { %>
                <div style="text-align:center; background:var(--surface-2); padding:20px; border-radius:8px;">
                    <span style="font-size:13px; color:var(--muted);">로그인 후 댓글을 작성할 수 있습니다.</span><br>
                    <a href="<%=request.getContextPath()%>/login" class="login-req-btn">로그인하기</a>
                </div>
            <% } %>
          </div>
        </div>

        <div class="notice">
          <div class="section-h" style="margin-bottom:6px">주의 사항</div>
          ※ 본 거래는 직거래로 진행됩니다. 구매 전 반드시 판매자와 협의해 주세요.
        </div>
      </div>
    </div>
  </div>
</section>

<script>
function toggleReplyForm(id) {
    var f = document.getElementById('reply-form-' + id);
    if (f.style.display === 'none') {
        f.style.display = 'block';
        f.querySelector('textarea').focus();
    } else {
        f.style.display = 'none';
    }
}
</script>

<% } %>
<%@ include file="../includes/footer.jspf" %>