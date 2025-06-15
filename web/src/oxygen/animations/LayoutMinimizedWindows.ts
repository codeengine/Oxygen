export function layoutMinimizedWindows(windows: HTMLElement[]) {
  windows.forEach((w, i) => {
    w.style.position = 'fixed';
    w.style.bottom = '0px';
    w.style.left = `${i * 120}px`;
  });
}
