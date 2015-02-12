class d3.chart.LineLegend extends d3.chart.BaseChart

    constructor: ->
        @accessors = {} unless @accessors?
        @accessors.color_value = (d) -> d.name
        @accessors.color_scale = d3.scale.category20()
        super

    _draw: (element, data, i) ->
                 
        # convenience accessors
        width = @width()
        height = @height()
        margin = @margin()
        color_value = @color_value()
        color_scale = @color_scale()

        # get unique color names
        color_names = (data.map color_value).filter (d, i, self) ->
            self.indexOf d == i

        color_scale.domain color_names

        legend_group = d3.select element
            .selectAll ".legends"
            .data [color_scale.domain()]
            .enter()

        legend_group.append "g"
            .classed "legends", true
            
        legend_group.exit().remove()

        legends = legend_group.selectAll ".legend"
            .data (d) -> d
            .enter()

        legends.each (d) ->
            lines = d3.select this
                .selectAll "line"
                .data [d]
                .enter()

            lines
                .append "line"
                .classed "line", true
                .attr "x1", width - 100
                .attr "x2", width - 50
                .attr "y1", 0.1 * height
                .attr "y2", 0.1 * height
                .attr "stroke", color_scale

            lines.exit().remove()

            texts = d3.select this
                .selectAll "text"
                .data [d]
                .enter()

            texts.append "text"
                .attr "x", width
                .attr "y", 0.1 * height
                .attr "dy", 0.05 * height
                .style "text-anchor", "end"
                .text (d) -> d

            texts.exit().remove()


        legends.attr "transform", (d, i) ->
            "translate(0, #{(0.1 * height) * i})"

        legends.exit().remove()
