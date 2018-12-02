const fs = require('fs');

fs.readFile('input.txt', 'utf8', (err, data) => {
  data = data.split("\n").map((e) => e.split(''));
  let foundIndex = -1;
  let thisOne;
  while(foundIndex === -1 && data.length > 0) {
    thisOne = data.shift();
    foundIndex = data.findIndex((element) => {
      let diffCount = 0;
      for(let i = 0; i < element.length; i++) {
        if(diffCount > 1) {
          break;
        }

        if(element[i] !== thisOne[i]) {
          diffCount++;
        }
      }

      return diffCount === 1;
    });
  }

  if(foundIndex) {
    console.log(thisOne.filter((letter, index) => {
      return letter === data[foundIndex][index];
    }).join(''));
  } else {
    console.log('nope');
  }
});
