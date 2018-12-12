const fs = require('fs');

function isUpper(letter) {
  return letter === letter.toUpperCase();
}

fs.readFile('input.txt', 'utf8', (err, data) => {
  const monster = data.split('');
  monster.pop();
  // const monster = 'dabAcCaCBAcCcaDA'.split('');
  const alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
  // const alphabet = 'abcd'.split('');
  const lengths = [];
  // monster = 'abBA'.split('');
  const deletions = [];
  while(alphabet.length > 0) {
    const removeLetter = alphabet.shift();
    // console.log('Trying Letter: ', removeLetter);
    const testArray = monster.filter(letter => letter.toLowerCase() !== removeLetter);

    while(true) {
      if(testArray.length <= 1) {
        break;
      }

      const nextDeletion = testArray.findIndex((e, i) => {
        if(!testArray[i+1]) {
          return false;
        }

        if(isUpper(e) !== isUpper(testArray[i+1])
          && e.toUpperCase() === testArray[i+1].toUpperCase()) {
          return true;
        }
      });

      if(nextDeletion === -1) {
        break;
      }

      testArray.splice(nextDeletion, 2);
      // console.log(testArray);
    }

    lengths.push(testArray.length);
    // console.log(testArray.join(''));
  }

  // console.log(monster);
  console.log(lengths.sort((x, y) => x - y)[0]);
});
