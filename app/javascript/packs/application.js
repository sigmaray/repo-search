import axios from 'axios';

import debounce from './../functions/debounce';

import setupAxios from './../functions/setup-axios';
setupAxios();

document.addEventListener('DOMContentLoaded', () => {
  let repoSearchInputs = document.querySelectorAll('input[data-role="repo-search-input"]');

  repoSearchInputs.forEach(function(input) {
    const searchRepos = () => {
      axios.post(
        input.dataset.url,
        { query: input.value }
      ).then(function (response) {
        console.log(response);
      });
    };

    input.addEventListener('keyup', debounce(searchRepos, 250));
  });
})
