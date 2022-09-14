// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "jquery/dist/jquery";
import "hammerjs/hammer";
import "bootstrap/dist/js/bootstrap";
import "bootstrap/dist/css/bootstrap";
require("jquery")

//= require jquery3
//= require jquery_ujs
//= require hammer
//= require jquery.hammer
//= require_tree .

window.$ = jQuery;

Rails.start();
Turbolinks.start();
ActiveStorage.start();

$(document).ready(function () {
  ("use strict");

  const matchContainer = document.querySelector(".match");
  const allCards = document.querySelectorAll(".match--card");
  const nope = document.querySelectorAll("nope");
  const love = document.querySelectorAll("love");

  function initCards(card, index) {
    const newCards = document.querySelectorAll(".match--card:not(.removed)");

    newCards.forEach(function (card, index) {
      card.style.zIndex = allCards.length - index;
      card.style.transform =
        "scale(" + (20 - index) / 20 + ") translateY(-" + 30 * index + "px)";
      card.style.opacity = (10 - index) / 10;
    });
    matchContainer.classList.add("loaded");
  }

  initCards();

  allCards.forEach(function (el) {
    const hammertime = new Hammer(el);

    hammertime.on("pan", function (event) {
      el.classList.add("moving");
    });

    hammertime.on("pan", function (event) {
      if (event.deltaX === 0) return;
      if (event.center.x === 0 && event.center.y === 0) return;

      matchContainer.classList.toggle("match_love", event.deltaX > 0);
      matchContainer.classList.toggle("match_nope", event.deltaX < 0);

      const xMulti = event.deltaX * 0.03;
      const yMulti = event.deltaY / 80;
      const rotate = xMulti * yMulti;

      event.target.style.transform =
        "translate(" +
        event.deltaX +
        "px, " +
        event.deltaY +
        "px) rotate(" +
        rotate +
        "deg)";
    });

    hammertime.on("panend", function (event) {
      el.classList.remove("moving");
      matchContainer.classList.remove("match_love");
      matchContainer.classList.remove("match_nope");

      const moveOutWidth = document.body.clientWidth;
      const keep =
        Math.abs(event.deltaX) < 80 || Math.abs(event.velocityX) < 0.5;

      event.target.classList.toggle("removed", !keep);

      if (keep) {
        event.target.style.transform = "";
      } else {
        const endX = Math.max(
          Math.abs(event.velocityX) * moveOutWidth,
          moveOutWidth
        );
        const toX = event.deltaX > 0 ? endX : -endX;
        const endY = Math.abs(event.velocityY) * moveOutWidth;
        const toY = event.deltaY > 0 ? endY : -endY;
        const xMulti = event.deltaX * 0.03;
        const yMulti = event.deltaY / 80;
        const rotate = xMulti * yMulti;

        event.target.style.transform =
          "translate(" +
          toX +
          "px, " +
          (toY + event.deltaY) +
          "px) rotate(" +
          rotate +
          "deg)";
        initCards();
      }
    });
  });

  function createButtonListener(love) {
    return function (event) {
      const cards = document.querySelectorAll(".match--card:not(.removed)");
      const moveOutWidth = document.body.clientWidth * 1.5;

      if (!cards.length) return false;

      const card = cards[0];

      card.classList.add("removed");

      if (love) {
        card.style.transform =
          "translate(" + moveOutWidth + "px, -100px) rotate(-30deg)";
      } else {
        card.style.transform =
          "translate(-" + moveOutWidth + "px, -100px) rotate(30deg)";
      }

      initCards();

      event.preventDefault();
    };
  }

  // const nopeListener = createButtonListener(false);
  // const loveListener = createButtonListener(true);

  $('.nope').on('click', function () {
    createButtonListener(false);
  });

  // $('.love').on('click', function () {
  //   createButtonListener(true);
  // });


  // nope.addEventListener("click", nopeListener);
  // love.addEventListener("click", loveListener);
});

// global.toastr = require("toastr")
