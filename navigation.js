(() => {
  if (window.top !== window) {
    return;
  }

  if (document.getElementById("nixos-kiosk-navigation")) {
    return;
  }

  const bar = document.createElement("div");
  bar.id = "nixos-kiosk-navigation";

  bar.innerHTML = `
    <button id="kiosk-back" title="Zurück">←</button>
    <button id="kiosk-forward" title="Vor">→</button>
    <button id="kiosk-reload" title="Aktualisieren">⟳</button>
  `;

  const style = document.createElement("style");

  style.textContent = `
    #nixos-kiosk-navigation {
      position: fixed;
      top: 10px;
      left: 10px;
      z-index: 2147483647;

      display: flex;
      gap: 8px;

      padding: 8px;

      background: rgba(30, 30, 30, 0.90);
      border-radius: 10px;

      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.35);

      font-family: sans-serif;
    }

    #nixos-kiosk-navigation button {
      width: 58px;
      height: 52px;

      border: 0;
      border-radius: 8px;

      font-size: 30px;
      line-height: 1;

      cursor: pointer;
      user-select: none;
    }

    #nixos-kiosk-navigation button:active {
      transform: scale(0.94);
    }
  `;

  document.documentElement.appendChild(style);
  document.documentElement.appendChild(bar);

  document.getElementById("kiosk-back").addEventListener("click", () => {
    history.back();
  });

  document.getElementById("kiosk-forward").addEventListener("click", () => {
    history.forward();
  });

  document.getElementById("kiosk-reload").addEventListener("click", () => {
    location.reload();
  });
})();