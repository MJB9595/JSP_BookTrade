<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="repo.DataStore" %>
<%@ page import="model.Notification" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../includes/header.jspf" %>
<%
    if (headerUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    List<Notification> notis = DataStore.getUnreadNotifications(headerUser.getId());
    SimpleDateFormat sdf = new SimpleDateFormat("MM.dd HH:mm");
%>
<div class="card" style="max-width: 600px; margin: 40px auto; min-height: 400px;">
    <h2 style="margin-bottom: 20px; border-bottom: 1px solid var(--border); padding-bottom: 15px;">알림 센터</h2>
    <% if (notis.isEmpty()) { %>
        <div style="text-align:center; padding: 50px; color:var(--muted);">
            <span class="material-symbols-outlined" style="font-size: 48px; margin-bottom: 10px;">notifications_paused</span><br>새로운 알림이 없습니다.
        </div>
    <% } else { %>
        <ul style="list-style: none; padding: 0;">
            <% for (Notification n : notis) { %>
                <li style="border-bottom: 1px solid var(--border);">
                    <a href="<%=request.getContextPath()%>/books/notification/check?id=<%=n.getId()%>&link=<%=n.getLink()%>" style="display: block; padding: 16px; text-decoration: none; color: var(--text); transition: 0.2s;">
                        <div style="font-size: 15px; margin-bottom: 4px;"><%= n.getMessage() %></div>
                        <div style="font-size: 12px; color: var(--muted);"><%= sdf.format(n.getRegDate()) %></div>
                    </a>
                </li>
            <% } %>
        </ul>
    <% } %>
</div>
<%@ include file="../includes/footer.jspf" %>