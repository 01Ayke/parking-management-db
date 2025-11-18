const colors = [
    'linear-gradient(120deg, #f6d365 0%, #fda085 100%)',
    'linear-gradient(120deg, #a1c4fd 0%, #c2e9fb 100%)',
    'linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%)',
    'linear-gradient(120deg, #fccb90 0%, #d57eeb 100%)',
    'linear-gradient(120deg, #ff9a8b 0%, #ff6a88 100%)',
    'linear-gradient(120deg, #43e97b 0%, #38f9d7 100%)'
  ];
  
  setInterval(() => {
    const idx = Math.floor(Math.random() * colors.length);
    document.body.style.background = colors[idx];
  }, 10000);
  