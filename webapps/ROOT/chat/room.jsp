<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="repo.DataStore, model.Book" %>
<%@ include file="../includes/header.jspf" %>
<%
  String room = request.getParameter("room");
  String bookIdParam = request.getParameter("bookId");
  Book b = null;
  try { b = DataStore.findById(Integer.parseInt(bookIdParam)); } catch(Exception ignore){}
  String owner = (String)session.getAttribute("chatOwnerId");
  String buyer = (String)session.getAttribute("chatBuyerId");
%>
<div class="card" style="max-width:780px;margin:0 auto">
  <h2>채팅방 <small style="font-size:12px;color:#94a3b8">(<%=room != null ? room : ""%>)</small></h2>
  <% if (b != null) { %>
    <p style="margin-top:4px">도서: <b><%=b.getTitle()%></b></p>
  <% } %>
  <p class="small">참여자: 판매자(<%=owner %>) · 구매자(<%=buyer %>)</p>

  <div id="messages" style="height:280px;border:1px solid #334155;border-radius:8px;padding:10px;overflow:auto;background:#0b1220;margin-top:8px"></div>
  <div style="display:flex;gap:8px;margin-top:8px">
    <input id="msg" placeholder="메시지를 입력하세요">
    <button onclick="send()" class="btn">보내기</button>
  </div>
</div>
<script>
function send(){
  var m = document.getElementById('msg').value.trim();
  if(!m) return;
  var box = document.getElementById('messages');
  var p = document.createElement('p');
  p.textContent = '나: ' + m;
  box.appendChild(p);
  document.getElementById('msg').value='';
  box.scrollTop = box.scrollHeight;
}
</script>
<%@ include file="../includes/footer.jspf" %>
