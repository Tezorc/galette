<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Member labels PDF
 *
 * PHP version 5
 *
 * Copyright © 2014 The Galette Team
 *
 * This file is part of Galette (http://galette.tuxfamily.org).
 *
 * Galette is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Galette is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Galette. If not, see <http://www.gnu.org/licenses/>.
 *
 * @category  IO
 * @package   Galette
 *
 * @author    Johan Cwiklinski <johan@x-tnd.be>
 * @copyright 2014 The Galette Team
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL License 3.0 or (at your option) any later version
 * @version   SVN: $Id$
 * @link      http://galette.tuxfamily.org
 * @since     Available since 0.8.2dev - 2014-12-01
 */

namespace Galette\IO;

use Galette\Core\Preferences;
use Analog\Analog;

/**
 * Member labels PDF
 *
 * @category  IO
 * @name      PDF
 * @package   Galette
 * @abstract  Class for expanding TCPDF.
 * @author    Johan Cwiklinski <johan@x-tnd.be>
 * @copyright 2014 The Galette Team
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL License 3.0 or (at your option) any later version
 * @link      http://galette.tuxfamily.org
 * @since     Available since 0.8.2dev - 2014-12-01
 */

class PdfMembersLabels extends Pdf
{
    private $xorigin;
    private $yorigin;
    private $lw;
    private $lh;
    private $line_h;

    /**
     * Main constructor, set creator and author
     *
     * @param Preferences $prefs Preferences
     */
    public function __construct(Preferences $prefs)
    {
        parent::__construct($prefs);
        $this->setRTL(false);
        $this->filename = __('labels_print_filename') . '.pdf';
        $this->init();
    }

    /**
     * Initialize PDF
     *
     * @return void
     */
    private function init()
    {
        // Set document information
        $this->SetTitle(_T("Member's Labels"));
        $this->SetSubject(_T("Generated by Galette"));
        $this->SetKeywords(_T("Labels"));

        // No hearders and footers
        $this->SetPrintHeader(false);
        $this->SetPrintFooter(false);
        $this->setFooterMargin(0);
        $this->setHeaderMargin(0);

        // Show full page
        $this->SetDisplayMode('fullpage');

        // Disable Auto Page breaks
        $this->SetAutoPageBreak(false, 0);

        // Set colors
        $this->SetDrawColor(160, 160, 160);
        $this->SetTextColor(0);

        // Set margins
        $this->SetMargins(
            $this->preferences->pref_etiq_marges_h,
            $this->preferences->pref_etiq_marges_v
        );

        // Set font
        //$this->SetFont(self::FONT);

        // Set origin
        // Top left corner
        $this->xorigin = $this->preferences->pref_etiq_marges_h;
        $this->yorigin = $this->preferences->pref_etiq_marges_v;

        // Label width
        $this->lw = round($this->preferences->pref_etiq_hsize);
        // Label heigth
        $this->lh = round($this->preferences->pref_etiq_vsize);
        // Line heigth
        $this->line_h=round($this->lh/5);
    }

    /**
     * Draw members cards
     *
     * @param array $members Members
     *
     * @return void
     */
    public function drawLabels($members)
    {
        $nb_etiq=0;
        foreach ($members as $member) {
            // Detect page breaks
            $colsrows = $this->preferences->pref_etiq_cols
                * $this->preferences->pref_etiq_rows;
            if ($nb_etiq % $colsrows == 0) {
                $this->AddPage();
            }
            // Set font
            $this->SetFont(self::FONT, 'B', $this->preferences->pref_etiq_corps);

            // Compute label position
            $col = $nb_etiq % $this->preferences->pref_etiq_cols;
            $row = ($nb_etiq / $this->preferences->pref_etiq_cols)
                % $this->preferences->pref_etiq_rows;
            // Set label origin
            $x = $this->xorigin + $col*(
                round($this->preferences->pref_etiq_hsize) +
                round($this->preferences->pref_etiq_hspace)
            );
            $y = $this->yorigin + $row*(
                round($this->preferences->pref_etiq_vsize) +
                round($this->preferences->pref_etiq_vspace)
            );
            // Draw a frame around the label
            $this->Rect($x, $y, $this->lw, $this->lh);
            // Print full name
            $this->SetXY($x, $y);
            $this->Cell($this->lw, $this->line_h, $member->sfullname, 0, 0, 'L', 0);
            // Print first line of address
            $this->SetFont(self::FONT, '', $this->preferences->pref_etiq_corps);
            $this->SetXY($x, $y + $this->line_h);

            //calculte font size to display address and address continuation
            $max_text_size = $this->preferences->pref_etiq_hsize;
            $text = mb_strlen($member->address) > mb_strlen($member->address_continuation) ?
                $member->address :
                $member->address_continuation;
            $this->fixSize(
                $text,
                $max_text_size,
                $this->preferences->pref_etiq_corps
            );

            $this->Cell($this->lw, $this->line_h, $member->address, 0, 0, 'L', 0);
            // Print second line of address
            $this->SetXY($x, $y + $this->line_h*2);
            $this->Cell(
                $this->lw,
                $this->line_h,
                $member->address_continuation,
                0,
                0,
                'L',
                0
            );
            // Print zip code and town
            $this->SetFont(self::FONT, 'B', $this->preferences->pref_etiq_corps);
            $text = $member->zipcode . ' - ' . $member->town;
            $this->fixSize(
                $text,
                $max_text_size,
                $this->preferences->pref_etiq_corps,
                'B'
            );

            $this->SetXY($x, $y + $this->line_h*3);
            $this->Cell(
                $this->lw,
                $this->line_h,
                $text,
                0,
                0,
                'L',
                0
            );
            // Print country
            $this->SetFont(self::FONT, 'I', $this->preferences->pref_etiq_corps);
            $this->SetXY($x, $y + $this->line_h*4);
            $this->Cell($this->lw, $this->line_h, $member->country, 0, 0, 'R', 0);
            $nb_etiq++;
        }
    }
}
