function multiplyVec2ByMatrix(vec, mat)
    vec = vec4(vec.x, vec.y, 0, 1)
    local resultVec = vec4(
    mat[1]*vec[1] + mat[5]*vec[2] + mat[09]*vec[3] + mat[13]*vec[4],
    mat[2]*vec[1] + mat[6]*vec[2] + mat[10]*vec[3] + mat[14]*vec[4],
    mat[3]*vec[1] + mat[7]*vec[2] + mat[11]*vec[3] + mat[15]*vec[4],
    mat[4]*vec[1] + mat[8]*vec[2] + mat[12]*vec[3] + mat[16]*vec[4]
    )
    return vec2(resultVec.x, resultVec.y)
end

function localToWorld(localPoint,mm)
    return multiplyVec2ByMatrix(localPoint, mm)
end

function worldToLocal(worldPoint,mm)
    if mm:determinant() == 0 then
        return nil
    else
        local resultVec = multiplyVec2ByMatrix(worldPoint, mm:inverse())
        return vec2(resultVec.x, resultVec.y)
    end
end

