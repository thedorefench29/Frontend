
    // Mock DB
    const studentRecords = ["20215489","20218765","20221234"];
    const accounts = {};

    // Elements
    const signInForm = document.getElementById('signInForm');
    const signUpForm = document.getElementById('signUpForm');
    const showSignUpBtn = document.getElementById('showSignUp');
    const backToSignIn = document.getElementById('backToSignIn');
    const signInBtn = document.getElementById('signInBtn');

    const step1 = document.getElementById('step1');
    const step2 = document.getElementById('step2');
    const studentNumberInput = document.getElementById('studentNumber');
    const verifyBtn = document.getElementById('verifyBtn');
    const statusWrap = document.getElementById('statusWrap');
    const studentError = document.getElementById('studentError');
    const studentSuccess = document.getElementById('studentSuccess');

    const generatedEmail = document.getElementById('generatedEmail');
    const newPassword = document.getElementById('newPassword');
    const repeatPassword = document.getElementById('repeatPassword');
    const strengthBar = document.getElementById('strengthBar');
    const pwError = document.getElementById('pwError');
    const createAccountBtn = document.getElementById('createAccountBtn');
    const backBtn = document.getElementById('backBtn');

    // Utility: show/hide sign up vs sign in
    function openSignUp(){
      signInForm.style.display = 'none';
      signUpForm.style.display = 'block';
      signUpForm.setAttribute('aria-hidden','false');
      signInForm.setAttribute('aria-hidden','true');
      step1.style.display = 'block';
      step2.style.display = 'none';
      statusWrap.textContent = '';
      studentError.style.display = 'none';
      studentSuccess.style.display = 'none';
      generatedEmail.value = '';
      createAccountBtn.disabled = true;
      studentNumberInput.value = '';
      newPassword.value = '';
      repeatPassword.value = '';
      strengthBar.style.width = '0';
    }
    function openSignIn(){
      signUpForm.style.display = 'none';
      signInForm.style.display = 'block';
      signUpForm.setAttribute('aria-hidden','true');
      signInForm.setAttribute('aria-hidden','false');
    }

    // initial state: show sign in
    openSignIn();

    showSignUpBtn.addEventListener('click', openSignUp);
    backToSignIn.addEventListener('click', openSignIn);
    backBtn.addEventListener('click', openSignUp);

    // verify student number
    verifyBtn.addEventListener('click', () => {
      const val = (studentNumberInput.value || '').trim();
      const pattern = /^\d{8}$/;
      statusWrap.textContent = '';
      studentError.style.display = 'none';
      studentSuccess.style.display = 'none';

      if (!pattern.test(val)) {
        studentError.textContent = 'Student Number must be exactly 8 digits.';
        studentError.style.display = 'block';
        return;
      }

      // loading state
      verifyBtn.disabled = true;
      studentNumberInput.disabled = true;
      statusWrap.textContent = 'Verifying…';
      
      // simulate network
      setTimeout(() => {
        verifyBtn.disabled = false;
        studentNumberInput.disabled = false;

        if (studentRecords.includes(val)) {
          statusWrap.textContent = 'Student number found ✅';
          studentSuccess.textContent = 'Student number verified. Proceed to create a password.';
          studentSuccess.style.display = 'block';
          studentError.style.display = 'none';

          // generate email and show step 2
          generatedEmail.value = val + '@sdcu.edu.ph';

          step1.style.display = 'none';
          step2.style.display = 'block';
          /* focus */
          newPassword.focus();
        } else {
          statusWrap.textContent = '';
          studentError.textContent = 'Student Number not found. Please enroll or contact admin.';
          studentError.style.display = 'block';
          studentSuccess.style.display = 'none';
        }
      }, 700);
    });

    // password strength checker (basic)
    function calcStrength(pw){
      let score = 0;
      if (!pw) return 0;
      if (pw.length >= 8) score += 1;
      if (/[A-Z]/.test(pw) && /[a-z]/.test(pw)) score += 1;
      if (/\d/.test(pw)) score += 1;
      if (/[^A-Za-z0-9]/.test(pw)) score += 1;
      return Math.min(score, 3);
    }

    newPassword.addEventListener('input', ()=> {
      const s = calcStrength(newPassword.value);
      if (!newPassword.value) {
        strengthBar.style.width = '0';
      } else if (s <= 1) {
        strengthBar.style.width = '33%';
      } else if (s === 2) {
        strengthBar.style.width = '66%';
      } else {
        strengthBar.style.width = '100%';
      }
      checkPasswords();
    });

    repeatPassword.addEventListener('input', checkPasswords);

    function checkPasswords(){
      const a = newPassword.value;
      const b = repeatPassword.value;
      if (!b) {
        pwError.style.display = 'none';
        createAccountBtn.disabled = true;
        return;
      }
      if (a === b && a.length >= 8) {
        pwError.style.display = 'none';
        createAccountBtn.disabled = false;
      } else {
        pwError.style.display = 'block';
        pwError.textContent = 'Passwords do not match or are too short (min 8 chars).';
        createAccountBtn.disabled = true;
      }
    }

    // create account
    signUpForm.addEventListener('submit', (e) => {
      e.preventDefault();
      // (we use step2 submit)
    });

    createAccountBtn.addEventListener('click', ()=>{
      const email = generatedEmail.value;
      const pw = newPassword.value;
      const sn = studentNumberInput.value;

      accounts[email] = { password: pw, studentNumber: sn };
      alert('✅ Account created!\n\n' + email + '\nYou can now sign in.');
      openSignIn();
      document.getElementById('signInEmail').value = email;
    });

    // sign in submit
    signInForm.addEventListener('submit', (e)=>{
      e.preventDefault();
      const email = document.getElementById('signInEmail').value.trim();
      const pw = document.getElementById('signInPassword').value;
      if (accounts[email] && accounts[email].password === pw) {
        alert('✅ Welcome back — signed in as ' + email);
      } else {
        alert('❌ Invalid email or password. Please try again.');
      }
    });

    // keyboard UX: press enter on studentNumber to verify
    studentNumberInput.addEventListener('keydown', (ev)=>{
      if (ev.key === 'Enter') { ev.preventDefault(); verifyBtn.click(); }
    });
