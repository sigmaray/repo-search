import debounce from './../functions/debounce';

import setupAxios from './../functions/setup-axios';
setupAxios();

document.addEventListener('DOMContentLoaded', () => {
  let repoSearchInputs = document.querySelectorAll('input[data-role="repo-search-input"]');

  repoSearchInputs.forEach(function(input) {
    const searchRepos = () => {
      console.log(input.value)
    };

    input.addEventListener('keyup', debounce(searchRepos, 250));
  });
})
