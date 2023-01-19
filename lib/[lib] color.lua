local color = function (color_r, color_g, color_b, color_a)

    return (function ()
        local color_function = {};
        color_function.__index = color_function;
    
        function color_function:get()
            return {
                r = self.r,
                g = self.g,
                b = self.b,
                a = self.a
            }
        end
    
        function color_function:unpack()
            return self.r, self.g, self.b, self.a
        end
    
        function color_function:set(color, color_2, color_3, color_4)
    
            local color_r, color_g, color_b, color_a
            if type(color) == "userdata" then
                color_r, color_g, color_b, color_a = color:r(), color:g(), color:b(), color:a()
            elseif type(color) == "table" then
                if color.r ~= nil then
                    color_r, color_g, color_b, color_a = color.r, color.g, color.b, color.a
                else
                    color_r, color_g, color_b, color_a = color[1], color[2], color[3], color[4]
                end
            elseif type(color) == "number" then
                color_r, color_g, color_b, color_a = color, color_2, color_3, color_4
            else
                return
            end
    
            self.r = color_r;
            self.g = color_g;
            self.b = color_b;
            self.a = color_a;
            
        end
    
        function color_function.new(color_r, color_g, color_b, color_a)

            if type(color_r) == "userdata" then
                color_r, color_g, color_b, color_a = color_r:r(), color_r:g(), color_r:b(), color_r:a()
            elseif type(color_r) == "table" then
                if color_r.r ~= nil then
                    color_r, color_g, color_b, color_a = color_r.r, color_r.g, color_r.b, color_r.a
                else
                    color_r, color_g, color_b, color_a = color_r[1], color_r[2], color_r[3], color_r[4]
                end
            elseif type(color_r) == "number" then
                color_r, color_g, color_b, color_a = color_r, color_g, color_b, color_a
            else
                return
            end

            return setmetatable({
                r = color_r,
                g = color_g,
                b = color_b,
                a = color_a,
             }, color_function)
        end

        return color_function

    end)().new(color_r, color_g, color_b, color_a)

end
