%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Copyright (c) 2011 Trey Hunner                                          %
%                                                                          %
%  Permission is hereby granted, free of charge, to any person obtaining   %
%  a copy of this software and associated documentation files (the         %
%  "Software"), to deal in the Software without restriction, including     %
%  without limitation the rights to use, copy, modify, merge, publish,     %
%  distribute, sublicense, and/or sell copies of the Software, and to      %
%  permit persons to whom the Software is furnished to do so, subject to   %
%  the following conditions:                                               %
%                                                                          %
%  The above copyright notice and this permission notice shall be          %
%  included in all copies or substantial portions of the Software.         %
%                                                                          %
%  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,         %
%  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF      %
%  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                   %
%  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE  %
%  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION  %
%  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION   %
%  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.         %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProvidesClass{invoice}

\LoadClass[12pt]{article}

\usepackage[letterpaper,hmargin=0.79in,vmargin=0.79in]{geometry}
\usepackage[parfill]{parskip}
\usepackage{fp} 
\usepackage{calc} 
\usepackage{longtable}
\usepackage[utf8x]{inputenc}
\usepackage[frenchb]{babel}
\usepackage{eurosym}

\pagestyle{empty} 
\linespread{1.5} 

\setlength{\doublerulesep}{\arrayrulewidth} 

\newcommand{\feetype}[1]{
    \textbf{#1}
    \\
}

\newcounter{hours} \newcounter{subhours} \newcounter{cost} \newcounter{subcost}
\setcounter{hours}{0} \setcounter{subhours}{0} \setcounter{cost}{0} \setcounter{subcost}{0}

\newcommand*{\formatNumber}[1]{\FPround{\cost}{#1}{2}\cost} %

\newcommand*{\total}[1]{\FPdiv{\t}{\arabic{#1}}{1000}\formatNumber{\t}}

\newenvironment{invoiceTable}{
    \newcommand*{\unitrow}[4]{%
         \addtocounter{cost}{1000 * \real{##2} * \real{##3}}%
         \addtocounter{subcost}{1000 * \real{##2} * \real{##3}}%
         ##1 & \formatNumber{##2} ##4 & \formatNumber{##3} \euro & \FPmul{\cost}{##2}{##3}\formatNumber{\cost} \euro%
         \\
    }
    \newcommand*{\feerow}[2]{%
         \addtocounter{cost}{1000 * \real{##2}}%
         \addtocounter{subcost}{1000 * \real{##2}}%
         ##1 & & \formatNumber{##2} \euro & \FPmul{\cost}{##2}{1}\formatNumber{\cost} \euro %
         \\
    }

    \newcommand{\subtotalNoStar}{
        {\bf Subtotal} &  &  & {\bf \total{subcost} \euro}
        \setcounter{subcost}{0}
        \setcounter{subhours}{0}
        \\*[1.5ex]
    }
    \newcommand{\subtotalStar}{
        {\bf Subtotal} & & & {\bf \$\total{subcost}}
        \setcounter{subcost}{0}
        \\*[1.5ex]
    }
    \newcommand{\subtotal}{
         \hline
         \@ifstar
         \subtotalStar%
         \subtotalNoStar%
    }

    \newcommand*{\hourrow}[3]{%
        \addtocounter{hours}{1000 * \real{##2}}%
        \addtocounter{subhours}{1000 * \real{##2}}%
        \unitrow{##1}{##2}{##3}{heures}%
    }
    \renewcommand{\tabcolsep}{0.8ex}
    \setlength\LTleft{0pt}
    \setlength\LTright{0pt}
    \begin{longtable}{@{\extracolsep{\fill}\hspace{\tabcolsep}} l r r r }
    \hline
    {\bf Description des services} & \multicolumn{1}{c}{\bf Quantité} & \multicolumn{1}{c}{\bf Prix unitaire} & \multicolumn{1}{c}{\bf Total} \\*
    \hline\hline
    \endhead
}{
    \hline\hline\hline
    {\bf Total} & & & {\bf \total{cost} \euro } \\
    \end{longtable}
}