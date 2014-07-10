#stack overflow http://stackoverflow.com/questions/23462320/r-interactive-plots-tooltips-rcharts-dimple-plot-formatting-axis

#For information, the chart above is based on the data put together by Thomas Piketty and Emmanuel Saez in their study of U.S. top incomes. The data and more may be found on their website, e.g.
#http://elsa.berkeley.edu/users/saez/
#http://piketty.pse.ens.fr/en/


df <- read.csv(
  "https://gist.githubusercontent.com/ptoche/872a77b5363356ff5399/raw/ac86ca43931baa7cd2e17719025c8cde1c278fc1/ps-income-shares.csv",
  stringsAsFactors = F
)


library("ggplot2")
library("scales")
df$YearDate <- as.Date(df$Year)
gp <- ggplot(data = df, aes(x = YearDate, y = value, color = Fractile))
gp <- gp + geom_line()
gp <- gp + theme_bw()
gp <- gp + scale_x_date(limits = as.Date(c("1911-01-01", "2023-01-01")), labels = date_format("%Y"))
gp <- gp + scale_y_continuous(labels = percent)
gp <- gp + theme(legend.position = "none")
gp <- gp + geom_text(data = subset(df, Year == "2012-01-01"), aes(x = YearDate, label = Fractile, hjust = -0.2), size = 4)
gp <- gp + xlab("")
gp <- gp + ylab("")
gp <- gp + ggtitle("U.S. top income shares (%)")
gp

library("rCharts")
p <- dPlot(
  value ~ Year,
  groups = c("Fractile"),
  data = df,
  type = "line",
  height = 400,
  width = 700,
  bounds = list(x = 50, y = 50, height = 300, width = 550)
)
p$xAxis(inputFormat = '%Y-%m-%d', outputFormat = '%Y')
p$yAxis(outputFormat = "%")
p$setTemplate(afterScript = "
              <script>
              {{chartId}}[0].axes[0].timeField = 'Year'
              {{chartId}}[0].axes[0].timePeriod = d3.time.years
              {{chartId}}[0].axes[0].timeInterval = 5
              {{chartId}}[0].draw()
              
              //if we wanted to change  our line width to match the ggplot chart
              {{chartId}}[0].series[0].shapes.style('stroke-width',1);
              
              //if we wanted to label our plot
              {{chartId}}[0].svg.append('g')
              .selectAll('text')
              .data(
              d3.nest().key(function(d){
              return d.cx
              }).map({{chartId}}[0].series[0]._positionData)[{{chartId}}[0].axes[0]._max])
              .enter()
              .append('text')
              .text(function(d){return d.aggField[0]})
              .attr('x',function(d){return {{chartId}}[0].axes[0]._scale(d.cx)})
              .attr('y',function(d){return {{chartId}}[0].axes[1]._scale(d.cy)})
              .attr('dy','.3em')
              .style('font-size','80%')
              .style('fill',function(d){return {{chartId}}[0]._assignedColors[d.aggField[0]].fill})
              
              </script>               
              ")
p$defaultColors(ggplot_build(gp)$data[[2]]$colour)
p
