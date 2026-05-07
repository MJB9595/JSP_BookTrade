<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="repo.DataStore" %>
<%@ page import="model.Notice" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ include file="../includes/header.jspf" %>

<%
    String cat = request.getParameter("cat");
    if (cat == null) cat = "all";

    List<Notice> notices = DataStore.getNotices(cat);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
%>

<style>
.notice-header { margin-bottom: 20px; }
.notice-tabs { display: flex; gap: 10px; border-bottom: 1px solid var(--border); padding-bottom: 12px; margin-bottom: 20px; }
.notice-tab { padding: 8px 16px; border-radius: 20px; font-size: 14px; font-weight: 600; color: var(--muted); text-decoration: none; transition: 0.2s; }
.notice-tab:hover { background: var(--surface-2); color: var(--text); }
.notice-tab.active { background: var(--primary); color: #fff; }

.notice-list { display: flex; flex-direction: column; gap: 12px; }
.notice-item { display: flex; align-items: center; justify-content: space-between; background: var(--card-bg); border: 1px solid var(--border); padding: 16px 20px; border-radius: 12px; transition: 0.2s; cursor: pointer; }
.notice-item:hover { transform: translateY(-2px); box-shadow: var(--shadow); border-color: var(--primary); }

.notice-info { display: flex; flex-direction: column; gap: 4px; }
.notice-cat { font-size: 12px; font-weight: 700; display: inline-block; padding: 2px 6px; border-radius: 4px; width: fit-content; }
.cat-공지 { color: #3b82f6; background: #eff6ff; }
.cat-이벤트 { color: #ec4899; background: #fdf2f8; }
.cat-업데이트 { color: #10b981; background: #ecfdf5; }
.notice-title { font-size: 16px; font-weight: 600; color: var(--text); }
.notice-date { font-size: 13px; color: var(--muted); }
</style>

<div class="container">
    <div class="card" style="min-height: 600px;">
        <div class="notice-header">
            <h2>공지사항 / 이벤트</h2>
            <p style="color:var(--muted);">유니북트레이드의 새로운 소식을 확인하세요.</p>
        </div>

        <div class="notice-tabs">
            <a href="?cat=all" class="notice-tab <%= "all".equals(cat) ? "active" : "" %>">전체</a>
            <a href="?cat=공지" class="notice-tab <%= "공지".equals(cat) ? "active" : "" %>">공지</a>
            <a href="?cat=이벤트" class="notice-tab <%= "이벤트".equals(cat) ? "active" : "" %>">이벤트</a>
            <a href="?cat=업데이트" class="notice-tab <%= "업데이트".equals(cat) ? "active" : "" %>">업데이트</a>
        </div>

        <div class="notice-list">
            <% if (notices.isEmpty()) { %>
                <div style="text-align:center; padding:40px; color:var(--muted);">등록된 게시물이 없습니다.</div>
            <% } else { 
                 for (Notice n : notices) {
            %>
                <div class="notice-item" onclick="location.href='detail.jsp?id=<%=n.getId()%>'">
                    <div class="notice-info">
                        <span class="notice-cat cat-<%=n.getCategory()%>"><%=n.getCategory()%></span>
                        <span class="notice-title"><%=n.getTitle()%></span>
                    </div>
                    <span class="notice-date"><%= sdf.format(n.getRegDate()) %></span>
                </div>
            <%   } 
               } %>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jspf" %>