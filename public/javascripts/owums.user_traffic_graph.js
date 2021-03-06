/*
# This file is part of the OpenWISP User Management System
#
# Copyright (C) 2012 OpenWISP.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

$.getJSON(owums.path('stats/user_traffic.json'), function(traffic){
    graphs.init({
        chart: {
            renderTo: 'user_traffic_graph',
            type: 'column'
        },
        title: { text: null },
        credits: { enabled: false },
        legend: { borderWidth: 0 },
        xAxis: {
            gridLineWidth: 1,
            tickLength: 2,
            type: 'datetime',
            minPadding: 0.05,
            maxPadding: 0.05
        },
        yAxis: {
            title: { text: null },
            labels: {
                formatter: function() { return graphs.bytes_formatter(this.value, true); }
            }
        },
        tooltip: {
            formatter: function() {
                return '<span style="font-size:10px">'+Highcharts.dateFormat('%A, %b %e, %Y', this.x)+'<br/><strong>'+graphs.bytes_formatter(this.y, true)+'</strong></span>';
            }
        },
        series: traffic
    });
});
