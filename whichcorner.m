function response = whichcorner(m,n,imageheight,imagewidth)
if m ==1
    
    if n ==1
        response = 1;
    elseif n == imagewidth
        response = 2;
    else
        response = 3;
    end
    
elseif m == imageheight
    
    if n ==1
        response = 4;
    elseif n == imagewidth
        response = 5;
    else
        response = 6;
    end
    
elseif n == 1
    
    if m ==1
        response = 1;
    elseif m == imageheight
        response = 4;
    else
        response = 7;
    end
    
elseif n == imagewidth
    if m ==1
        response = 2;
    elseif m == imageheight
        response = 5;
    else
        response = 8;
    end
else
    response = 9;
end
end