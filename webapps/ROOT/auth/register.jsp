<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../includes/header.jspf" %>

<style>
/* 중복확인 버튼 및 메시지 스타일 */
.input-group { display: flex; gap: 8px; }
.check-btn { 
    white-space: nowrap; padding: 10px 16px; 
    background: var(--surface-2); border: 1px solid var(--border); 
    color: var(--text); border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 600;
}
.check-btn:hover { background: var(--border); }
.check-msg { font-size: 12px; margin-top: 4px; display: block; min-height: 18px; }
.msg-success { color: #10b981; } /* 초록색 */
.msg-error { color: #ef4444; }   /* 빨간색 */
</style>

<div class="card" style="max-width:520px; margin:40px auto; padding:32px;">
  <h2 style="text-align:center; margin-bottom:24px;">회원가입</h2>
  
  <form action="<%=request.getContextPath()%>/register" method="post" onsubmit="return validateForm()">
    
    <div class="form-group" style="margin-bottom:16px;">
        <label style="display:block; margin-bottom:6px; font-weight:600; color:var(--muted);">아이디</label>
        <div class="input-group">
            <input type="text" id="userId" name="id" required placeholder="아이디 입력"
                   style="flex:1; padding:10px; border:1px solid var(--border); border-radius:8px; background:var(--surface); color:var(--text);"
                   oninput="resetCheck()"> <button type="button" class="check-btn" onclick="checkDuplicate()">중복확인</button>
        </div>
        <span id="idCheckMsg" class="check-msg"></span>
    </div>

    <div class="form-group" style="margin-bottom:16px;">
        <label style="display:block; margin-bottom:6px; font-weight:600; color:var(--muted);">비밀번호</label>
        <input type="password" name="pw" required style="width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; background:var(--surface); color:var(--text);">
    </div>

    <div class="form-group" style="margin-bottom:16px;">
        <label style="display:block; margin-bottom:6px; font-weight:600; color:var(--muted);">이름</label>
        <input type="text" name="name" required style="width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; background:var(--surface); color:var(--text);">
    </div>

    <div class="form-group" style="margin-bottom:16px;">
        <label style="display:block; margin-bottom:6px; font-weight:600; color:var(--muted);">학교</label>
        <input type="text" name="school" placeholder="예: 한국대학교" required style="width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; background:var(--surface); color:var(--text);">
    </div>

    <div class="form-group" style="margin-bottom:24px;">
        <label style="display:block; margin-bottom:6px; font-weight:600; color:var(--muted);">학번</label>
        <input type="text" name="studentNo" placeholder="예: 20230001" required style="width:100%; padding:10px; border:1px solid var(--border); border-radius:8px; background:var(--surface); color:var(--text);">
    </div>

    <button type="submit" class="btn btn-primary" style="width:100%; padding:12px; font-size:16px;">가입하기</button>
  </form>
</div>

<script>
// 중복 확인 상태 플래그 (true면 사용 가능, false면 불가)
let isIdChecked = false;

// 1. 중복 확인 함수 (AJAX)
function checkDuplicate() {
    const idInput = document.getElementById('userId');
    const msgSpan = document.getElementById('idCheckMsg');
    const id = idInput.value.trim();

    if (!id) {
        msgSpan.textContent = "아이디를 입력해주세요.";
        msgSpan.className = "check-msg msg-error";
        return;
    }

    // 서버로 비동기 요청
    fetch('<%=request.getContextPath()%>/checkId?id=' + encodeURIComponent(id))
        .then(response => response.json())
        .then(data => {
            if (data.available) {
                msgSpan.textContent = "사용 가능한 아이디입니다.";
                msgSpan.className = "check-msg msg-success";
                isIdChecked = true; // 통과
            } else {
                msgSpan.textContent = "이미 사용 중인 아이디입니다.";
                msgSpan.className = "check-msg msg-error";
                isIdChecked = false;
            }
        })
        .catch(err => {
            console.error(err);
            alert("중복 확인 중 오류가 발생했습니다.");
        });
}

// 2. 아이디 입력 변경 시 체크 상태 초기화
function resetCheck() {
    isIdChecked = false;
    const msgSpan = document.getElementById('idCheckMsg');
    msgSpan.textContent = ""; // 메시지 지움
}

// 3. 폼 제출 시 검증
function validateForm() {
    if (!isIdChecked) {
        alert("아이디 중복 확인을 해주세요.");
        document.getElementById('userId').focus();
        return false; // 전송 막기
    }
    return true; // 전송 허용
}
</script>

<%@ include file="../includes/footer.jspf" %>