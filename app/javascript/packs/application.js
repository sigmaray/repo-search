import './../../stylesheets/app.css';

import axios from 'axios';

import debounce from './../functions/debounce';

import setupAxios from './../functions/setup-axios';
setupAxios();

document.addEventListener('DOMContentLoaded', () => {
  const resultsContainer = document.getElementById('repo-search-results');
  const itemTemplate = resultsContainer.dataset.itemTemplate;
  const repoSearchInputs = document.querySelectorAll('input[data-role="repo-search-input"]');

  let lastQuery = '';

  repoSearchInputs.forEach(function(input) {
    const searchRepos = () => {
      if (input.value === lastQuery) { return };
      lastQuery = input.value;

      axios.post(
        input.dataset.url,
        { query: input.value }
      ).then(function (response) {
        resultsContainer.innerHTML = response.data.map((itemData) => {
          let html = itemTemplate;
          html = html.replace('{{htmlUrl}}', itemData.html_url);
          html = html.replace('{{repo}}', itemData.name);
          html = html.replace('{{owner}}', itemData.owner);
          html = html.replace('{{stargazersCount}}', itemData.stargazers_count);

          return html;
        }).join('');
      });
    };

    input.addEventListener('keydown', () => {
      if (input.value !== lastQuery) { resultsContainer.innerHTML = '' }
    });

    input.addEventListener('keyup', debounce(searchRepos, 100));
  });
})
