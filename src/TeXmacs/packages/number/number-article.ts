<TeXmacs|1.0.3.4>

<style|source>

<\body>
  <active*|<\src-title>
    <src-package-dtd|number-article|1.0|number-section|1.0>

    <\src-purpose>
      Numbering articles.
    </src-purpose>

    <src-copyright|1998--2004|Joris van der Hoeven>

    <\src-license>
      This <TeXmacs> style package falls under the <hlink|GNU general public
      license|$TEXMACS_PATH/LICENSE> and comes WITHOUT ANY WARRANTY
      WHATSOEVER. If you do not have a copy of the license, then write to the
      Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
      02111-1307, USA.
    </src-license>
  </src-title>>

  <assign|section-nr|0>

  <assign|appendix-nr|0>

  \;

  <assign|resetsection|<macro|<assign|subsection-nr|0>>>

  <assign|resetsubsection|<macro|<assign|subsubsection-nr|0>>>

  <assign|resetsubsubsection|<macro|>>

  \;

  <assign|the-section|<macro|<value|section-nr>>>

  <assign|the-subsection|<macro|<the-section>.<value|subsection-nr>>>

  <assign|the-subsubsection|<macro|<the-subsection>.<value|subsubsection-nr>>>

  <assign|the-prefix|<macro|>>

  \;
</body>

<\initial>
  <\collection>
    <associate|page-bot|30mm>
    <associate|page-even|30mm>
    <associate|page-odd|30mm>
    <associate|page-reduce-bot|15mm>
    <associate|page-reduce-left|25mm>
    <associate|page-reduce-right|25mm>
    <associate|page-reduce-top|15mm>
    <associate|page-right|30mm>
    <associate|page-top|30mm>
    <associate|page-type|a4>
    <associate|par-width|150mm>
    <associate|preamble|true>
    <associate|sfactor|4>
  </collection>
</initial>