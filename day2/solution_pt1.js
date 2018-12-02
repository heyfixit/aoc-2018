const fs = require('fs');

fs.readFile('input.txt', 'utf8', (err, data) => {
  data = data.split("\n");
  const counts = data.reduce((memo, thisOne, idx) => {
    const array = thisOne.split('').sort();
    let doubleFound = false;
    let tripleFound = false;
    while (array.length > 0 && !(tripleFound && doubleFound)) {
      const thisLetter = array.shift();

      const count = array.lastIndexOf(thisLetter) + 2;
      if(count === 3) {
        tripleFound = true;
      } else if(count === 2) {
        doubleFound = true;
      }
      array.splice(0, count - 1);
    }
    doubleFound && memo.doubles++;
    tripleFound && memo.triples++;

    return memo;
  }, { doubles: 0, triples: 0 });

  console.log(counts.doubles * counts.triples);
});
