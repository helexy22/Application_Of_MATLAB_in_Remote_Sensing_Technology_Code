classdef HistogramAccumulator < handle
    properties
        Histogram
        Range
    end

    methods
        function obj = HistogramAccumulator()
            obj.Range = [];
            obj.Histogram = [];
        end

        function addToHistogram(obj,new_data)
            if isempty(obj.Histogram)
                obj.Range = double(0:intmax(class(new_data)));
                obj.Histogram = hist(double(new_data(:)),obj.Range);
            else
                new_hist = hist(double(new_data(:)),obj.Range);
                obj.Histogram = obj.Histogram + new_hist;
            end
        end
    end
end
