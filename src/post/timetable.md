---
title: Tabella oraria delle lezioni
description: Un'idea interessante è quella di avere una tabella personalizzabile con gli orari delle lezioni
date: 2020/09/11
tags: 
    - draft
draft: true
---

Qualche giorno fa ho scoperto questa pagina <http://poisson.phc.dm.unipi.it/~resteghini/timetable/> (tutti i crediti per l'idea vanno a questo studente) e mi è venuta voglia di tentare di ricrearla aggiungendo qualche feature.

## Risultato

<style>
    #container {
        display: flex;
        flex-direction: column-reverse;

        position: absolute;
        left: 50%;
        transform: translateX(-50%);
        min-width: 45rem;
        width: max-content;
        max-width: 90vw;
    }

    input[type=checkbox] {
        display: flex;
        flex-direction: row;

        position: relative;
        color: #333;
        font: var(--font-text);

        height: 1.5rem;
    }

    input[type=checkbox]::after {
        content: attr(data-label);
        position: absolute;
        left: 100%;
        top: -1px;
        margin-left: 0.5rem;

        width: max-content;
    }

    table, th, td {
        text-align: center;
        border: 1px solid #aaa;

        margin-bottom: 1.5rem;
    }

    .corso {
        display: none;
    }

    .corso.algebra-1:checked ~ table td .corso.algebra-1,
    .corso.analisi-1:checked ~ table td .corso.analisi-1,
    .corso.analisi-2:checked ~ table td .corso.analisi-2,
    .corso.analisi-3:checked ~ table td .corso.analisi-3,
    .corso.analisi-numerica:checked ~ table td .corso.analisi-numerica,
    .corso.aritmetica:checked ~ table td .corso.aritmetica,
    .corso.calcolo-scientifico:checked ~ table td .corso.calcolo-scientifico,
    .corso.edp:checked ~ table td .corso.edp,
    .corso.ega:checked ~ table td .corso.ega,
    .corso.fisica-2:checked ~ table td .corso.fisica-2,
    .corso.geometria-1:checked ~ table td .corso.geometria-1,
    .corso.geometria-2:checked ~ table td .corso.geometria-2,
    .corso.gtd:checked ~ table td .corso.gtd,
    .corso.inglese:checked ~ table td .corso.inglese,
    .corso.laboratorio-computazionale:checked ~ table td .corso.laboratorio-computazionale,
    .corso.lcmc:checked ~ table td .corso.lcmc,
    .corso.logica:checked ~ table td .corso.logica,
    .corso.mepvsa:checked ~ table td .corso.mepvsa,
    .corso.probabilità:checked ~ table td .corso.probabilità,
    .corso.programmazione:checked ~ table td .corso.programmazione,
    .corso.ricerca-operativa:checked ~ table td .corso.ricerca-operativa,
    .corso.sistemi-dinamici:checked ~ table td .corso.sistemi-dinamici,
    .corso.storia:checked ~ table td .corso.storia {
        display: initial;
    }


</style>

<div id="container">
<input type="checkbox" class="corso storia" data-label="Storia della Matematica"/>
<input type="checkbox" class="corso sistemi-dinamici" data-label="Sistemi Dinamici"/>
<input type="checkbox" class="corso ricerca-operativa" data-label="Ricerca Operativa"/>
<input type="checkbox" class="corso programmazione" data-label="Programmazione"/>
<input type="checkbox" class="corso probabilità" data-label="Probabilità"/>
<input type="checkbox" class="corso mepvsa" data-label="Matematiche Elementari da un Punto di Vista Superiore: Aritmetica"/>
<input type="checkbox" class="corso logica" data-label="Logica"/>
<input type="checkbox" class="corso lcmc" data-label="Laboratorio di Comunicazione Mediante Calcolatore"/>
<input type="checkbox" class="corso laboratorio-computazionale" data-label="Laboratorio Computazionale"/>
<input type="checkbox" class="corso inglese" data-label="Inglese Scientifico"/>
<input type="checkbox" class="corso gtd" data-label="Geometria e Topologia Differenziale">
<input type="checkbox" class="corso geometria-2" data-label="Geometria 2"/>
<input type="checkbox" class="corso geometria-1" data-label="Geometria 1"/>
<input type="checkbox" class="corso fisica-2" data-label="Fisica 2"/>
<input type="checkbox" class="corso ega" data-label="Elementi di Geometria Algebrica"/>
<input type="checkbox" class="corso edp" data-label="Equazioni alle Derivate Parziali"/>
<input type="checkbox" class="corso calcolo-scientifico" data-label="Calcolo Scientifico"/>
<input type="checkbox" class="corso aritmetica" data-label="Aritmetica"/>
<input type="checkbox" class="corso analisi-numerica" data-label="Analisi Numerica"/>
<input type="checkbox" class="corso analisi-3" data-label="Analisi 3"/>
<input type="checkbox" class="corso analisi-2" data-label="Analisi 2"/>
<input type="checkbox" class="corso analisi-1" data-label="Analisi 1"/>
<input type="checkbox" class="corso algebra-1" data-label="Algebra 1"/>
<table>
    <thead>
        <th></th>
        <th>Lunedì</th>
        <th>Martedì</th>
        <th>Mercoledì</th>
        <th>Giovedì</th>
        <th>Venerdì</th>
    </thead>
    <tbody>
        <tr>
            <th>9:00 - 10:45</th>
            <td>
                <div data-shortname="Algebra 1" class="corso algebra-1">Algebra 1</div>
                <div data-shortname="Aritmetica" class="corso aritmetica">Aritmetica</div>
                <div data-shortname="G.T.D." class="corso gtd">Geometria e Topologia Differenziale</div>                
                <div data-shortname="Lab.Computazionale" class="corso laboratorio-computazionale">Laboratorio Computazionale</div>                
            </td>
            <td>
                <div data-shortname="Analisi Numerica" class="corso analisi-numerica">Analisi Numerica</div>
                <div data-shortname="G.T.D." class="corso gtd">Geometria e Topologia Differenziale</div>                
                <div data-shortname="Programmazione" class="corso programmazione">Programmazione</div>
            </td>
            <td>
                <div data-shortname="Analisi 3" class="corso analisi-3">Analisi 3</div>
                <div data-shortname="Geometria 1" class="corso geometria-1">Geometria 1</div>
                <div data-shortname="Geometria 2" class="corso geometria-2">Geometria 2</div>
            </td>
            <td>
                <div data-shortname="Geometria 2" class="corso geometria-2">Geometria 2</div>
                <div data-shortname="Programmazione" class="corso programmazione">Programmazione</div>
                <div data-shortname="Probabilità" class="corso probabilità">Probabilità</div>
            </td>
            <td>
                <div data-shortname="Analisi 2" class="corso analisi-2">Analisi 2</div>
                <div data-shortname="Geometria 1" class="corso geometria-1">Geometria 1</div>
                <div data-shortname="Logica" class="corso logica">Logica</div>
            </td>
        </tr>
        <tr>
            <th>11:00 - 12:45</th>
            <td>
                <div data-shortname="Analisi 3" class="corso analisi-3">Analisi 3</div>
                <div data-shortname="Analisi Numerica" class="corso analisi-numerica">Analisi Numerica</div>
                <div data-shortname="L.C.M.C. (A)" class="corso lcmc">Laboratorio Computazionale Mediante Calcolatore (A)</div>
            </td>
            <td>
                <div data-shortname="Algebra 1" class="corso algebra-1">Algebra 1</div>
                <div data-shortname="Analisi 1" class="corso analisi-1">Analisi 1</div>
                <div data-shortname="Fisica 2" class="corso fisica-2">Fisica 2</div>
                <div data-shortname="Ricerca Operativa" class="corso ricerca-operativa">Ricerca Operativa</div>
            </td>
            <td>
                <div data-shortname="Analisi 2" class="corso analisi-2">Analisi 2</div>
                <div data-shortname="Ricerca Operativa" class="corso ricerca-operativa">Ricerca Operativa</div>
            </td>
            <td>
                <div data-shortname="Analisi 1" class="corso analisi-1">Analisi 1</div>
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <th>14:00 - 15:45</th>
            <td>
                <div data-shortname="Geometria 1" class="corso geometria-1">Geometria 1</div>
                <div data-shortname="Inglese Sci." class="corso inglese">Inglese Scientifico</div>
                <div data-shortname="S.d.M." class="corso storia">Storia della Matematica</div>
            </td>
            <td>
                <div data-shortname="Calcolo Sci." class="corso calcolo-scientifico">Calcolo Scientifico</div>
                <div data-shortname="E.G.A." class="corso ega">Elementi di Geometria Algebrica</div>
                <div data-shortname="E.D.P." class="corso edp">Equazioni alle Derivate Parziali</div>
            </td>
            <td>
                <div data-shortname="Analisi 1" class="corso analisi-1">Analisi 1</div>
                <div data-shortname="Calcolo Sci." class="corso calcolo-scientifico">Calcolo Scientifico</div>
                <div data-shortname="Inglese Sci." class="corso inglese">Inglese Scientifico</div>
            </td>
            <td>
                <div data-shortname="Analisi Numerica" class="corso analisi-numerica">Analisi Numerica</div>
                <div data-shortname="Aritmetica" class="corso aritmetica">Aritmetica</div>
                <div data-shortname="G.T.D" class="corso gtd">Geometria e Topologia Differenziale</div>
                <div data-shortname="MEPVS-Arit." class="corso mepvsa">Matematiche Elementari da un Punto di Vista Superiore: Aritmetica</div>
            </td>
            <td>
                <div data-shortname="Inglese Sci." class="corso inglese">Inglese Scientifico</div>
                <div data-shortname="Sistemi Dinamici" class="corso sistemi-dinamici">Sistemi Dinamici</div>
                <div data-shortname="S.d.M." class="corso storia">Storia della Matematica</div>
            </td>
        </tr>
        <tr>
            <th>16:00 - 17:45</th>
            <td>
                <div data-shortname="L.C.M.C. (B)" class="corso lcmc">Laboratorio Computazionale Mediante Calcolatore (B)</div>
                <div data-shortname="Logica" class="corso logica">Logica</div>
                <div data-shortname="Sistemi Dinamici" class="corso sistemi-dinamici">Sistemi Dinamici</div>
            </td>
            <td>
                <div data-shortname="Probabilità" class="corso probabilità">Probabilità</div>
            </td>
            <td>
                <div data-shortname="Algebra 1" class="corso algebra-1">Algebra 1</div>
                <div data-shortname="Fisica 2" class="corso fisica-2">Fisica 2</div>
                <div data-shortname="Programmazione" class="corso programmazione">Programmazione</div>
                <div data-shortname="Ricerca Operativa" class="corso ricerca-operativa">Ricerca Operativa</div>
            </td>
            <td>
                <div data-shortname="Analisi 2" class="corso analisi-2">Analisi 2</div>
                <div data-shortname="Analisi 3" class="corso analisi-3">Analisi 3</div>
                <div data-shortname="L.C.M.C." class="corso lcmc">Laboratorio di Comunicazione Mediante Calcolatore</div>
            </td>
            <td>
                <div data-shortname="E.G.A." class="corso ega">Elementi di Geometria Algebrica</div>
                <div data-shortname="E.D.P." class="corso edp">Equazioni alle Derivate Parziali</div>
                <div data-shortname="MEPVS-Arit." class="corso mepvsa">Matematiche Elementari da un Punto di Vista Superiore: Aritmetica</div>
            </td>
        </tr>
    </tbody>
</table>
</div>

























































