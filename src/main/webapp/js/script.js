const userButton = document.getElementById('userButton');
  const userDropdown = document.getElementById('userDropdown');

  userButton.addEventListener('click', () => {
    userDropdown.classList.toggle('visible');
  });

  // Tùy chọn: Đóng menu nếu click ra ngoài
  document.addEventListener('click', (e) => {
    if (!userButton.contains(e.target) && !userDropdown.contains(e.target)) {
      userDropdown.classList.remove('visible');
    }
  });

