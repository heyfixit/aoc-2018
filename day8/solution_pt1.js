const fs = require('fs');

function parseTree(data) {
  const node = {};
  node.child_count = data.shift();
  node.meta_count = data.shift();
  if(node.child_count > 0) {
    node.children = [];
    for(let i = 0; i < node.child_count; i++) {
      node.children.push(parseTree(data));
    }
  }

  if(node.meta_count > 0) {
    node.meta_data = []
    for(let i = 0; i < node.meta_count; i++) {
      node.meta_data.push(data.shift());
    }
  }

  return node;
}

function calcMetaSum(node) {
  let sum = 0;
  if(node.child_count > 0) {
    for(let i = 0; i < node.children.length; i++) {
      sum += calcMetaSum(node.children[i]);
    }
  }
  if(node.meta_count > 0) {
    sum += node.meta_data.reduce((accu, cur) => { return accu + cur; }, 0);
  }
  return sum;
}

fs.readFile('input.txt', 'utf8', (err, data) => {
  // data = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2";
  split_data = data.split(" ").map((d) => parseInt(d));

  tree = parseTree(split_data);
  console.log(calcMetaSum(tree));
});
