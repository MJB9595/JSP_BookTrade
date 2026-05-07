<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="repo.DataStore" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Book" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ include file="../includes/header.jspf" %>

<%
  List<Book> list = (List<Book>)request.getAttribute("books");
  if (list == null) {
      list = DataStore.findAll();
  }
%>

<div class="card">
  <h2><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "도서 목록" %></h2>

  <% if(list == null || list.isEmpty()) { %>
      <div style="padding:40px; text-align:center; color:var(--muted);">
          <p>등록된 도서가 없습니다.</p>
          <a href="<%=request.getContextPath()%>/books/new" class="btn btn-primary" style="margin-top:10px;">첫 번째 책 등록하기</a>
      </div>
  <% } else { %>

  <div class="grid book-grid">
    <%
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");

      for (Book b : list) {
        String ownerName = "알 수 없음";
        try {
          if (b.getOwnerId() != null) {
            User u = DataStore.findUser(b.getOwnerId());
            if (u != null && u.getName() != null) ownerName = u.getName();
          }
        } catch (Exception e) {}

        String dept  = (b.getDept()  != null) ? b.getDept()  : "";
        String grade = (b.getGrade() != null) ? b.getGrade() : "";
        String cond  = (b.getCondition() != null) ? b.getCondition() : "";
        
        String timeStr = "방금 전";
        if (b.getRegDate() != null) {
            timeStr = sdf.format(b.getRegDate());
        }
        
        // [NEW] 이미지 처리 로직
        String bookImg = request.getContextPath() + "/assets/img/sample-book.png";
        if (b.getBase64Image() != null) {
            bookImg = "data:image/png;base64," + b.getBase64Image();
        }
    %>

      <article class="book-card book-card-list">
        <div class="thumb-wrap">
          <img src="<%=bookImg%>" alt="book" style="object-fit:cover;">
        </div>

        <div class="book-body">
          <h3 class="book-title">
            <a href="<%=request.getContextPath()%>/books/detail?id=<%=b.getId()%>">
              <%= b.getTitle() %>
            </a>
          </h3>

          <p class="book-price">
            <span class="price-main">
              <%= String.format("%,d", b.getPrice()) %>원
            </span>
            <% if (!cond.isEmpty()) { %>
              <span class="price-sub">( <%= cond %> )</span>
            <% } %>
          </p>

          <p class="book-meta">
            <%= dept %>
            <% if (!grade.isEmpty()) { %> | <%= grade %>학년 <% } %>
          </p>
        </div>

        <hr class="book-sep">

        <div class="book-footer">
          <span class="owner"><%= ownerName %></span>
          <span class="time" style="font-size:12px; color:#888;"><%= timeStr %></span>
        </div>
      </article>

    <% } %>
  </div>
  <% } %>
</div>

<%@ include file="../includes/footer.jspf" %>