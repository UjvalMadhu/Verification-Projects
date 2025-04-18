///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                         4 Bit  Multiplier                                   ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   A simple 4 Bit Multiplier designed for verification purposes              ///
///                                                                             ///
///   Reference: Kumar Khandagle, Namaste FPGA                                  ///
///                                                                             ///
///   Copyright (C) 2025 Ujval Madhu,                                           ///
///   This program is free software: you can redistribute it and/or modify      ///
///   it under the terms of the GNU General Public License as published by      ///
///   the Free Software Foundation, either version 3 of the License, or         ///
///   (at your option) any later version.                                       ///
///                                                                             ///
///   This program is distributed in the hope that it will be useful,           ///
///   but WITHOUT ANY WARRANTY; without even the implied warranty of            ///
///   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             ///
///   GNU General Public License for more details.                              ///
///                                                                             ///
///   You should have received a copy of the GNU General Public License         ///
///   along with this program.  If not, see <https://www.gnu.org/licenses/>.    ///
///                                                                             ///
////////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: mul.v, v 1.0
//
//  $Date: 2025-4-7
//  $Revision: 1.0 
//  $Author:  Ujval Madhu

module mul(
  input  [3:0] a,b,
  output [7:0] y
);
  

assign y = a*b;
  

endmodule