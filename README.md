# [Emacs] Tempo-42Edition-c-cpp.el
## A Personal version of the tempo-c-cpp.el Template for Emacs, adding C and C++ skeletons.
**tempo-c-cpp.el** is a ELisp configuration file for Emacs adding a lot of templates for easy and fast to use skeletons.
I modified them and added some to get the perfect file for 42.
You're free to modify the file for your personal uses.

### INSTALLATION
#### Prerequisite
- `header.el` for `class` and `cclass`
- `comment.el` for `cclass`
- `list.el`, `comment.el` and `string.el` for `header.el`

#### Installation
Put the `tempo-42Edition-c-cpp.el` file in the Emacs configuration files Folder.
Then just put a `(require 'tempo-42Edition-c-cpp)` in your .emacs or .myemacs file.

If you don't have a configuration file Foler, please follow the next steps:
- Go in your `.emacs`
- Add the following lines
```
(setq config_files "xxx")
(setq load-path (append (list nil config_files) load-path))
```
Where "xxx" is your configuration file Folder name.
- Then follow the previous steps to load the `tempo-42Edition-c-cpp.el`.

### USAGE
- Run `M-x tempo-template-c-<xx>` (where <xx> is the name of the template) for C template or `tempo-template-c++-<xx>` for C++ templates
- Or type the corresponding abbreviation in Emacs and hit `C-RET` or `F5`

### TEMPLATES

| Abbreviation| Correspondant Sequence                      |
|-------------|---------------------------------------------|
|    **Preprocessor statements**                            |
|include      |    	#include                                |
|define       |    	#define                                 |
|ifdef        |       	#ifdef                              |
|ifndef       |   	#ifndef                                 |
|   **C statements**                                        |
|if           |	if (...) { }                                |
|else  		  |else { ... }                                 |
|ifelse 	  |if (...) { } else { }                        |
|while        | while (...) { }                             |
|for          |for (...) {;;}                               |
|forinc       |   for (var=0; var < limit; var++) { }       |
|fordec       |   for (var=value; var > 0; var--) { }       |
|foriinc      |   for (i=0; i < limit; i++) { }             |
|foridec      |   for (i=value; i > 0; i--) { }             |
|switch	      | switch() {...}                              |
|case	      | case: ... break;                            |
|main	      |	int main() { ... }                          |
|malloc	      | type * var = (type *) malloc(...)           |
|function     | type name() { return (); }                  |
| **C++ statements**                                        |
|class	      |class xxx { ... }; (For .hpp) (Canonical)    |
|cclass       |   class xxx { ... }; (For .cpp) (Canonical) |
|getset	      | accessor/mutator   (For .hpp) (Canonical)   |
|cgetset      |   accessor/mutator   (For .cpp) (Canonical) |
|cout         |   std::cout <<  << std::endl;               |
|cin          |   std::cin >> ;                             |

### EXAMPLES
#### class
```c++
// ************************************************************************** //
//                                                                            //
//                                                        :::      ::::::::   //
//   Sample.class.hpp                                   :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: Myrkskog <marvin@42.fr>                    +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2015/01/07 22:00:38 by Myrkskog          #+#    #+#             //
//   Updated: 2015/01/23 22:52:26 by Myrkskog         ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#ifndef SAMPLE_CLASS_HPP
# define SAMPLE_CLASS_HPP

# include <iostream>

class Sample {

public:
    Sample(void);
    Sample(Sample const & src);
    Sample(int var);
    ~Sample(void);
    
    /* Operator Overload */
    Sample &	operator=(Sample const & rhs);

    /* Accessors */
    int		getVar(void) const;

    /* Mutators */
    bool	setVar(int val);

private:
    int		_var;

};

#endif
```

#### cclass:
```c++
// ************************************************************************** //
//                                                        :::      ::::::::   //
//   Sample.class.cpp                                   :+:      :+:    :+:   //
//                                                    +:+ +:+         +:+     //
//   By: Myrkskog <marvin@42.fr>                    +#+  +:+       +#+        //
//                                                +#+#+#+#+#+   +#+           //
//   Created: 2015/01/07 21:58:28 by Myrkskog          #+#    #+#             //
//   Updated: 2015/01/07 21:58:28 by Myrkskog         ###   ########.fr       //
//                                                                            //
// ************************************************************************** //

#include "Sample.class.hpp"

// ************************************************************************** //
//                                    CORE                                    //
// ************************************************************************** //

Sample::Sample(void)
{}

Sample::Sample(Sample const & src)
{
    *this = src;
}
Sample::Sample(int var) : _var(var)
{}

Sample::~Sample(void)
{}

// ************************************************************************** //
//                                                                            //
//                             Operators Overload                             //
//                                                                            //
// ************************************************************************** //

Sample &	Sample::operator=(Sample const & rhs)
{
    if (this != &rhs)
    {
        this->_var = rhs.getVar();
    }
    return (*this);
}

// ************************************************************************** //
//                                                                            //
//                                 Accessors                                  //
//                                                                            //
// ************************************************************************** //

int			Sample::getVar(void) const
{
    return (this->_var);
}

// ************************************************************************** //
//                                                                            //
//                                  Mutators                                  //
//                                                                            //
// ************************************************************************** //

bool		Sample::setVar(int val)
{
    this->_var = val;
    return (true);
}
```

### SOURCES AND THANKS
- Thanks to Sebastien Varrette for the initial file : [tempo-c-cpp.el](http://www.emacswiki.org/emacs/tempo-c-cpp.el)
- Thanks to Sylvain Conso for the original [tempo-42Edition-c-cpp.el](https://github.com/Sconso/tempo-42Edition-c-cpp.el)
- Thanks to Emilien Baudet for his beta utilisation and advices : [GitHub](https://github.com/ebaudet)
