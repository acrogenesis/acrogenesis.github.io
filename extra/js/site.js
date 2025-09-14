// Theme toggle with persistence
(function() {
  function currentTheme() {
    try {
      var t = localStorage.getItem('theme');
      if (t === 'light' || t === 'dark') return t;
      if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) return 'dark';
      return 'light';
    } catch (_) {
      return 'light';
    }
  }

  function setTheme(t) {
    document.documentElement.setAttribute('data-theme', t);
    try { localStorage.setItem('theme', t); } catch (_) {}
    var el = document.getElementById('theme-toggle');
    if (el) el.textContent = 'theme: ' + t;
  }

  function toggleTheme() {
    var t = document.documentElement.getAttribute('data-theme') || currentTheme();
    setTheme(t === 'dark' ? 'light' : 'dark');
  }

  document.addEventListener('DOMContentLoaded', function() {
    setTheme(currentTheme());
    var el = document.getElementById('theme-toggle');
    if (el) el.addEventListener('click', toggleTheme);
  });
})();

// Lazy-load Disqus on demand
(function() {
  var loaded = false;

  function loadDisqus(shortname, identifier, title, url) {
    if (loaded) return;
    loaded = true;
    // Configure per-page context
    window.disqus_config = function () {
      this.page.url = url || window.location.href;
      this.page.identifier = identifier;
      this.page.title = title;
    };
    var d = document, s = d.createElement('script');
    s.src = 'https://' + shortname + '.disqus.com/embed.js';
    s.setAttribute('data-timestamp', +new Date());
    (d.head || d.body).appendChild(s);
  }

  document.addEventListener('DOMContentLoaded', function() {
    var btn = document.getElementById('comments-toggle');
    if (!btn) return;
    btn.addEventListener('click', function() {
      btn.disabled = true;
      btn.textContent = 'Loading comments…';
      loadDisqus(
        btn.getAttribute('data-disqus-shortname') || 'bluehats',
        btn.getAttribute('data-disqus-identifier') || window.location.pathname,
        btn.getAttribute('data-disqus-title') || document.title,
        btn.getAttribute('data-disqus-url') || window.location.href
      );
      // Hide button after a moment to keep UI tidy
      setTimeout(function(){ btn.style.display = 'none'; }, 800);
    });
  });
})();
