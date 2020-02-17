import axios from 'axios';

export default function () {
  const csrfToken = document.querySelector('meta[name=csrf-token]').content;
  axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
  axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
}
