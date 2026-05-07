<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="repo.DataStore" %>
<%@ page import="model.Notice" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ include file="../includes/header.jspf" %>

<%
    String idParam = request.getParameter("id");
    Notice n = null;
    if (idParam != null) {
        try { n = DataStore.getNoticeById(Integer.parseInt(idParam)); } catch(Exception e) {}
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
%>

<div class="container" style="max-width: 800px;">
    <% if (n == null) { %>
        <div class="card" style="padding:40px; text-align:center;">
            존재하지 않는 게시물입니다.<br><br>
            <a href="list.jsp" class="btn">목록으로</a>
        </div>
    <% } else { %>
        
        <div class="card">
            <div style="margin-bottom:16px; border-bottom:1px solid var(--border); padding-bottom:16px;">
                <span class="badge" style="margin-bottom:8px;"><%= n.getCategory() %></span>
                <h2 style="margin:0; font-size:24px;"><%= n.getTitle() %></h2>
                <p style="margin:8px 0 0; color:var(--muted); font-size:13px;">
                    게시일: <%= sdf.format(n.getRegDate()) %>
                </p>
            </div>

            <div style="min-height:200px; line-height:1.6; color:var(--text);">
                <% if (n.getBase64Image() != null) { %>
                    <img src="data:image/png;base64,<%=n.getBase64Image()%>" 
                         style="max-width:100%; border-radius:8px; margin-bottom:20px;">
                    <br>
                <% } %>
                
                <%= n.getContent().replace("\n", "<br>") %>
            </div>
            
            <div style="margin-top:30px; text-align:center; border-top:1px solid var(--border); padding-top:20px;">
                <a href="list.jsp" class="btn ghost">목록으로 돌아가기</a>
            </div>
        </div>
    <% } %>
</div>

<%@ include file="../includes/footer.jspf" %>