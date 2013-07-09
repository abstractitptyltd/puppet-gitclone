git
====

####Table of Contents

0. [Breaking Changes](#changes)
1. [New stuff and bug fixes](#new)
2. [Overview - What is the git module?](#overview)
3. [Module Description - What does the module do?](#module-description)
4. [Setup - The basics of getting started with git](#setup)
5. [Usage - The parameters available for configuration](#usage)
6. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [Development - Guide for contributing to the module](#development)
9. [Release Notes - Notes on the most recent updates to the module](#release-notes)

Breaking Changes
----------------

None yet I hope.

New stuff and bug fixes
-----------------------

See above.

Overview
--------

Puppet module for managing git clones. Will also checkout a branch or tag.

Module Description
------------------

Uses exec resources to clone a git repositorys

Setup
-----

    include git # this will make sure git is installed

    git::clone{ "code":
      source       => "(ssh|http)://git.domain.com:port/repo",
      localtree    => "/wherever",
      (branch|tag) => "(master|v1.0.0)",
    }

Usage
-----

variables to set
    $git::params::gitpackages  = ['git','somethingelse'] # uses ensure_packages to install these
    $git::params::user         = 'whoever'
    $git::params::group        = 'whatever'

Implementation
--------------


Limitations
------------


Development
-----------


Release Notes
-------------

**0.1.0**

Initial release
