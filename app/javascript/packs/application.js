import './../../stylesheets/app.css';

import axios from 'axios';

import debounce from './../functions/debounce';

import setupAxios from './../functions/setup-axios';
setupAxios();

document.addEventListener('DOMContentLoaded', () => {
  const resultsContainer = document.getElementById('repo-search-results');
  const repoSearchInputs = document.querySelectorAll('input[data-role="repo-search-input"]');

  let lastQuery = '';

  const renderSearchResults = function (data) {
    return data.map((itemData) => {
      let html = resultsContainer.dataset.itemTemplate;

      html = html.replace('{{htmlUrl}}', itemData.html_url);
      html = html.replace('{{repo}}', itemData.name.substring(0, 40));
      html = html.replace('{{owner}}', itemData.owner);
      html = html.replace('{{stargazersCount}}', itemData.stargazers_count);

      return html;
    }).join('');
  };

  const renderErrorMessage = function (errorMessage) {
    let html = resultsContainer.dataset.errorMessageTemplate;

    html = html.replace('{{errorMessage}}', errorMessage);

    return html;
  };

  repoSearchInputs.forEach(function(input) {
    const searchRepos = () => {
      if (input.value.length === 0) { return };
      if (input.value === lastQuery) { return };
      lastQuery = input.value;

      axios
        .post(input.dataset.url, { query: input.value })
        .then(function (response) {
          resultsContainer.innerHTML = renderSearchResults(response.data);
        })
        .catch(error => {
          resultsContainer.innerHTML = renderErrorMessage(error.response.data.message);
        });
    };

    input.addEventListener('keydown', () => {
      if (input.value !== lastQuery) { resultsContainer.innerHTML = '' }
    });

    input.addEventListener('keyup', debounce(searchRepos, 100));
  });
})
