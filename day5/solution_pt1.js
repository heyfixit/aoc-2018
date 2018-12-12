const fs = require('fs');

function isUpper(letter) {
  return letter === letter.toUpperCase();
}

fs.readFile('input.txt', 'utf8', (err, data) => {
  const monster = data.split('');
  monster.pop();
  // monster = 'abBA'.split('');
  // monster = 'dabAcCaCBAcCcaDA'.split('');
  const deletions = [];
  while(true) {
    if(monster.length <= 1) {
      break;
    }

    const nextDeletion = monster.findIndex((e, i) => {
      if(!monster[i+1]) {
        return false;
      }

      if(isUpper(e) !== isUpper(monster[i+1])
        && e.toUpperCase() === monster[i+1].toUpperCase()) {
        return true;
      }
    });

    if(nextDeletion === -1) {
      break;
    }

    monster.splice(nextDeletion, 2);
  }

  // console.log(monster);
  console.log(monster.length);
});
