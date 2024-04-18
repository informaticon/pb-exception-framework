# How to contribute

**If you send us code via a pull request, we assume it is licensed under the MIT license.**
We are open for feedback and we value suggestions.

## Testing

We have our own framework for unit testing which is not open source (yet).
If you want to hand in test cases, please to this by opening an issue and posting the code there (you can also provide us a [Github Gist](https://gist.github.com/) link).

## Submitting changes

Please send a GitHub Pull Request to to the main with a clear list of what you've done.
Please follow our coding conventions (below).

Always write a clear log message for your commits.

## Coding convention

Please follow these coding convention:

* We indent using tab characters (not spaces).
* We always put spaces after list items and method parameters (1, 2, 3, not 1,2,3) and around operators (lu_i += 1, not lu_i+=1).
* We write names (variables, objects, functions, ...) in camel_case (lbo_show_message, not lboMessageBox).
* We write keywords and inbuilt names in lowercase (this means, that **everything** is lowercase).
* We use variable prefixes (ai=argument  int, lbo=local boolean, is=public instance string, pu=protected/private instance object, ...).
* We use function prefixes (of=public function, pf=protected/private function, gf=global function).