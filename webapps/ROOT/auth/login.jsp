<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../includes/header.jspf" %>

<div class="card" style="max-width:460px; margin:60px auto; padding:32px;">
  <h2 style="text-align:center; margin-bottom:24px;">로그인</h2>
  
  <form action="<%=request.getContextPath()%>/login" method="post">
    <div class="form-group" style="margin-bottom:16px;">
        <label class="label" style="display:block; margin-bottom:6px; font-weight:600; color:var(--muted);">아이디</label>
        <input type="text" name="id" required style="width:100%; padding:12px; border:1px solid var(--border); border-radius:8px; background:var(--surface); color:var(--text);">
    </div>

    <div class="form-group" style="margin-bottom:24px;">
        <label class="label" style="display:block; margin-bottom:6px; font-weight:600; color:var(--muted);">비밀번호</label>
        <input type="password" name="pw" required style="width:100%; padding:12px; border:1px solid var(--border); border-radius:8px; background:var(--surface); color:var(--text);">
    </div>

    <div style="display:flex; gap:10px; margin-bottom:20px;">
        <button type="submit" class="btn btn-primary" style="flex:1; padding:12px; font-size:16px;">로그인</button>
        
        <a href="<%=request.getContextPath()%>/register" class="btn" style="flex:1; text-align:center; padding:12px; font-size:16px; background:transparent; border:1px solid var(--border); color:var(--text);">
            회원가입
        </a>
    </div>
  </form>

  <div style="text-align:center; margin-top:20px; font-size:13px; color:var(--muted);">
      테스트 계정: <code>student1 / 1234</code>
  </div>
</div>

<%@ include file="../includes/footer.jspf" %>