export default function (func, wait) {
  let timeout;

  return function() {
    clearTimeout(timeout);
    timeout = setTimeout(func, wait);
  };
}
