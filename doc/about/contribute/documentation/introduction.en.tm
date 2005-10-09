<TeXmacs|1.0.5.9>

<style|tmdoc>

<\body>
  <tmdoc-title|Introduction on how to contribute>

  High quality documentation is both a matter of content and structure. The
  content itself has to be as pedagogic as possible for the targeted group of
  readers. In order to achieve this, you should not hesitate to provide
  enough examples and illustrative screen shots whenever adequate. Although
  the documentation is not necessarily meant to be complete, we do aim at
  providing relatively stable documentation. In particular, you should have
  checked your text against spelling errors. The more experimental
  documentation should be put in the <verbatim|incoming> directory or on the
  <hyper-link|<TeXmacs> Wiki|http://alqua.com/tmresources>.

  It is also important that you give your documentation as much structure as
  possible, using special markup from the <tmstyle|tmdoc> style file. This
  structure can be used in order to automatically compile printable books
  from your documentation, to make it suitable for different ways of viewing,
  or to make it possible to efficiently search a certain type of information
  in the documentation. In particular, you should always provide
  <hyper-link|copyright and license|copyright.en.tm><inactive|> information,
  as well as indications on how to <hyper-link|traverse|traversal.en.tm> your
  documentation, if it contains <hyper-link|many files|file-names.en.tm>.

  <\warning>
    Don't forget to select <menu|Document|Language|Your language> for each
    translated file. This will cause some content to be translated
    automatically, like the menus or some names of keys. Also, we recommend
    to run the <TeXmacs> spell checker on each translated document; this also
    requires the prior selection of the right document language.
  </warning>

  <\warning>
    In recent versions of <TeXmacs>, documentation files are ``cached'', so
    to improve the performance of help searching. However, this may prevent
    <TeXmacs> from recognizing newly added documentation. When writing
    documentation, you should always start <TeXmacs> using

    <verbatim| \ \ \ texmacs --delete-doc-cache>

    so as to remove all old files in the cache.
  </warning>

  <tmdoc-copyright|1998--2002|Joris van der Hoeven>

  <tmdoc-license|Permission is granted to copy, distribute and/or modify this
  document under the terms of the GNU Free Documentation License, Version 1.1
  or any later version published by the Free Software Foundation; with no
  Invariant Sections, with no Front-Cover Texts, and with no Back-Cover
  Texts. A copy of the license is included in the section entitled "GNU Free
  Documentation License".>
</body>

<\initial>
  <\collection>
    <associate|language|english>
  </collection>
</initial>