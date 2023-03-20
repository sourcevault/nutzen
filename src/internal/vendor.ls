``
// The MIT License (MIT)

// Copyright (c) 2014, 2016, 2017 Simon Lydell
// Copyright (c) 2017 Randall Randall
// Copyright (c) 2019 Aito Intelligence Oy

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

function isObject (obj) {
  return typeof obj === 'object' && obj !== null
}

function forEach (obj, cb) {
  if (Array.isArray(obj)) {
    obj.forEach(cb)
  } else if (isObject(obj)) {
    Object.keys(obj).forEach(function (key) {
      var val = obj[key]
      cb(val, key)
    })
  }
}

function getTreeDepth (obj) {
  var depth = 0

  if (Array.isArray(obj) || isObject(obj)) {
    forEach(obj, function (val) {
      if (Array.isArray(val) || isObject(val)) {
        var tmpDepth = getTreeDepth(val)
        if (tmpDepth > depth) {
          depth = tmpDepth
        }
      }
    })

    return depth + 1
  }

  return depth
}

function stringify (obj, options) {
  options = options || {}
  var indent = JSON.stringify([1], null, get(options, 'indent', 2)).slice(2, -3)
  var addMargin = get(options, 'margins', false)
  var addArrayMargin = get(options, 'arrayMargins', false)
  var addObjectMargin = get(options, 'objectMargins', false)
  var maxLength = (indent === '' ? Infinity : get(options, 'maxLength', 80))
  var maxNesting = get(options, 'maxNesting', Infinity)

  return (function _stringify (obj, currentIndent, reserved) {
    if (obj && typeof obj.toJSON === 'function') {
      obj = obj.toJSON()
    }

    var string = JSON.stringify(obj)

    if (string === undefined) {
      return string
    }

    var length = maxLength - currentIndent.length - reserved

    var treeDepth = getTreeDepth(obj)
    if (treeDepth <= maxNesting && string.length <= length) {
      var prettified = prettify(string, {
        addMargin: addMargin,
        addArrayMargin: addArrayMargin,
        addObjectMargin: addObjectMargin
      })
      if (prettified.length <= length) {
        return prettified
      }
    }

    if (isObject(obj)) {
      var nextIndent = currentIndent + indent
      var items = []
      var delimiters
      var comma = function (array, index) {
        return (index === array.length - 1 ? 0 : 1)
      }

      if (Array.isArray(obj)) {
        for (var index = 0; index < obj.length; index++) {
          items.push(
            _stringify(obj[index], nextIndent, comma(obj, index)) || 'null'
          )
        }
        delimiters = '[]'
      } else {
        Object.keys(obj).forEach(function (key, index, array) {
          var keyPart = JSON.stringify(key) + ': '
          var value = _stringify(obj[key], nextIndent,
                                 keyPart.length + comma(array, index))
          if (value !== undefined) {
            items.push(keyPart + value)
          }
        })
        delimiters = '{}'
      }

      if (items.length > 0) {
        return [
          delimiters[0],
          indent + items.join(',\n' + nextIndent),
          delimiters[1]
        ].join('\n' + currentIndent)
      }
    }

    return string
  }(obj, '', 0))
}

// Note: This regex matches even invalid JSON strings, but since we’re
// working on the output of "JSON.stringify" we know that only valid strings
// are present (unless the user supplied a weird "options.indent" but in
// that case we don’t care since the output would be invalid anyway).

var stringOrChar = /("(?:[^\\"]|\\.)*")|[:,\][}{]/g

function prettify (string, options) {
  options = options || {}

  var tokens = {
    '{': '{',
    '}': '}',
    '[': '[',
    ']': ']',
    ',': ', ',
    ':': ': '
  }

  if (options.addMargin || options.addObjectMargin) {
    tokens['{'] = '{ '
    tokens['}'] = ' }'
  }

  if (options.addMargin || options.addArrayMargin) {
    tokens['['] = '[ '
    tokens[']'] = ' ]'
  }

  return string.replace(stringOrChar, function (match, string) {
    return string ? match : tokens[match]
  })
}

function get (options, name, defaultValue) {
  return (name in options ? options[name] : defaultValue)
}

``

####################################################################################################


``

// The MIT License (MIT)

// Copyright (c) 2018 Dineshkumar Pandiyan <flexdinesh@gmail.com>

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

function advancedPad(dir, string, len, chr = ' ', trunc = false) {
  // a string is a string is a string
  let str = String(string);
  const strLen = str.length;
  let i = 0;
  // check to truncate
  if (strLen > len) {
    if (trunc === true) {
      if (dir) {
        // right trunc
        return str.substr(0, len);
      }
      // left trunc
      return str.substr(strLen - len);
    }
    return str;
  } else {
    // start padding
    const padLen = len - strLen;
    while (i++ < padLen) {
      if (dir) {
        str += chr;
      } else {
        str = chr + str;
      }
    }
    // handle string output
    if (chr.length > 1) {
      if (dir) {
        return str.substr(0, len);
      }
      return str.substr(str.length - len);
    }
    return str;
  } // end trunc check
} // end advancedPad();

pad = {
  padLeft: advancedPad.bind(null, 0),
  padRight: advancedPad.bind(null, 1)
};

``

####################################################################################################

``

// MIT License
// Copyright (c) Sindre Sorhus <sindresorhus@gmail.com> (sindresorhus.com)
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

'use strict';

const collator = new Intl.Collator();
let compare = (left, right) => left === right ? 0 : collator.compare(left, right);

const brokenLocaleCompare = collator.compare('b', 'å') > -1;
if (brokenLocaleCompare) {
  compare = (left, right) => left > right ? 1 : left < right ? -1 : 0;
}

function caseInsensitiveCompare(left, right) {
  const lowercaseComparison = compare(left.toLowerCase(), right.toLowerCase());
  return lowercaseComparison === 0 ? compare(left, right) : lowercaseComparison;
}

alpha_sort = {}

alpha_sort.ascending = (left, right) => compare(left, right);
alpha_sort.descending = (left, right) => compare(right, left);
alpha_sort.caseInsensitiveAscending = (left, right) => caseInsensitiveCompare(left, right);
alpha_sort.caseInsensitiveDescending = (left, right) => caseInsensitiveCompare(right, left);


``

####################################################################################################

``
// This software is released to the public domain.

// It is based in part on the deepFreeze function from:

// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Object/freeze

// https://developer.mozilla.org/en-US/docs/Project:Copyrights

//  "author" : {
//  "name" : "James Halliday"
//   "email" : "mail@substack.net"
//   "url" : "http://substack.net"
// }

deepFreeze = function deepFreeze (o) {
  Object.freeze(o);

  Object.getOwnPropertyNames(o).forEach(function (prop) {
    if (o.hasOwnProperty(prop)
    && o[prop] !== null
    && (typeof o[prop] === "object" || typeof o[prop] === "function")
    && !Object.isFrozen(o[prop])) {
      deepFreeze(o[prop]);
    }
  });

  return o;
};
``

####################################################################################################

``

// Copyright (c) 2014, Hugh Kennedy

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

// 3. Neither the name of the  nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function isBuffer (obj) {
  return obj &&
    obj.constructor &&
    (typeof obj.constructor.isBuffer === 'function') &&
    obj.constructor.isBuffer(obj)
}

function keyIdentity (key) {
  return key
}

function flatten (target, opts) {
  opts = opts || {}

  const delimiter = opts.delimiter || '.'
  const maxDepth = opts.maxDepth
  const transformKey = opts.transformKey || keyIdentity
  const output = {}

  function step (object, prev, currentDepth) {
    currentDepth = currentDepth || 1
    Object.keys(object).forEach(function (key) {
      const value = object[key]
      const isarray = opts.safe && Array.isArray(value)
      const type = Object.prototype.toString.call(value)
      const isbuffer = isBuffer(value)
      const isobject = (
        type === '[object Object]' ||
        type === '[object Array]'
      )

      const newKey = prev
        ? prev + delimiter + transformKey(key)
        : transformKey(key)

      if (!isarray && !isbuffer && isobject && Object.keys(value).length &&
        (!opts.maxDepth || currentDepth < maxDepth)) {
        return step(value, newKey, currentDepth + 1)
      }

      output[newKey] = value
    })
  }

  step(target)

  return output
}

function unflatten (target, opts) {
  opts = opts || {}

  const delimiter = opts.delimiter || '.'
  const overwrite = opts.overwrite || false
  const transformKey = opts.transformKey || keyIdentity
  const result = {}

  const isbuffer = isBuffer(target)
  if (isbuffer || Object.prototype.toString.call(target) !== '[object Object]') {
    return target
  }

  // safely ensure that the key is
  // an integer.
  function getkey (key) {
    const parsedKey = Number(key)

    return (
      isNaN(parsedKey) ||
      key.indexOf('.') !== -1 ||
      opts.object
    ) ? key
      : parsedKey
  }

  function addKeys (keyPrefix, recipient, target) {
    return Object.keys(target).reduce(function (result, key) {
      result[keyPrefix + delimiter + key] = target[key]

      return result
    }, recipient)
  }

  function isEmpty (val) {
    const type = Object.prototype.toString.call(val)
    const isArray = type === '[object Array]'
    const isObject = type === '[object Object]'

    if (!val) {
      return true
    } else if (isArray) {
      return !val.length
    } else if (isObject) {
      return !Object.keys(val).length
    }
  }

  target = Object.keys(target).reduce(function (result, key) {
    const type = Object.prototype.toString.call(target[key])
    const isObject = (type === '[object Object]' || type === '[object Array]')
    if (!isObject || isEmpty(target[key])) {
      result[key] = target[key]
      return result
    } else {
      return addKeys(
        key,
        result,
        flatten(target[key], opts)
      )
    }
  }, {})

  Object.keys(target).forEach(function (key) {
    const split = key.split(delimiter).map(transformKey)
    let key1 = getkey(split.shift())
    let key2 = getkey(split[0])
    let recipient = result

    while (key2 !== undefined) {
      if (key1 === '__proto__') {
        return
      }

      const type = Object.prototype.toString.call(recipient[key1])
      const isobject = (
        type === '[object Object]' ||
        type === '[object Array]'
      )

      // do not write over falsey, non-undefined values if overwrite is false
      if (!overwrite && !isobject && typeof recipient[key1] !== 'undefined') {
        return
      }

      if ((overwrite && !isobject) || (!overwrite && recipient[key1] == null)) {
        recipient[key1] = (
          typeof key2 === 'number' &&
          !opts.object ? [] : {}
        )
      }

      recipient = recipient[key1]
      if (split.length > 0) {
        key1 = getkey(split.shift())
        key2 = getkey(split[0])
      }
    }

    // unflatten again for 'messy objects'
    recipient[key1] = unflatten(target[key], opts)
  })

  return result
}

flatten.flatten = flatten
flatten.unflatten = unflatten

``
####################################################################################################

module.exports =
  *stringify:stringify
   pad:pad
   alpha_sort:alpha_sort
   deepFreeze:deepFreeze
   flat:flatten

