// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from '../css/app.css';

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import 'phoenix_html';

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import $ from 'jquery';

const workingBlocks = {};

window.saveBlock = blockId => {
  $.ajax({
    url: `/blocks/${blockId}`,
    method: 'PUT',
    data: $(`#block-${blockId}`).serialize(),
  });
};

window.deleteBlock = blockId => {
  $.ajax({
    url: `/blocks/${blockId}`,
    method: 'DELETE',
    data: $(`#block-${blockId}`).serialize(),
  });
  $(`#block-${blockId}`).remove();
};

window.stopBlockClock = (taskId, token) => {
  $.ajax({
    url: `/blocks`,
    method: 'POST',
    data: {
      start: workingBlocks[taskId],
      end: new Date().toISOString(),
      task_id: taskId,
      _csrf_token: token,
    },
  });
  $(`#block-clock-${taskId}`).text('START WORKING');
  $(`#block-clock-${taskId}`).removeAttr('onclick');
  $(`#block-clock-${taskId}`).attr(
    'onclick',
    `startBlockClock(${taskId}, '${token}')`,
  );
  document.location.reload();
};

window.startBlockClock = (taskId, token) => {
  $(`#block-clock-${taskId}`).text('STOP WORKING');
  $(`#block-clock-${taskId}`).removeAttr('onclick');
  $(`#block-clock-${taskId}`).attr(
    'onclick',
    `stopBlockClock(${taskId}, '${token}')`,
  );
  workingBlocks[taskId] = new Date().toISOString();
};

// const delete = () => {
//     $.remove()
// }
