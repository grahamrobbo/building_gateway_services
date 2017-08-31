KNWebGLShader={};KNWebGLShader.defaultTexture={attribNames:["Position","TexCoord"],uniformNames:["MVPMatrix","Texture"],vertex:"        #ifdef GL_ES\n        precision highp float;\n        #endif\n        uniform mat4    MVPMatrix;\n        attribute vec4  Position;\n        attribute vec2  TexCoord;\n        varying vec2 v_TexCoord;\n        void main()\n        {\n            v_TexCoord = TexCoord;\n            gl_Position = (MVPMatrix * Position);\n        }        ",fragment:"        #ifdef GL_ES\n        precision mediump float;\n        #endif\n        uniform sampler2D Texture;\n        varying vec2 v_TexCoord;\n        void main()\n        {\n            gl_FragColor = texture2D(Texture, v_TexCoord);\n        }        "};KNWebGLShader.defaultTextureAndOpacity={attribNames:["Position","TexCoord"],uniformNames:["MVPMatrix","Texture","Opacity"],vertex:"        #ifdef GL_ES\n        precision highp float;\n        #endif\n        uniform mat4    MVPMatrix;\n        attribute vec4  Position;\n        attribute vec2  TexCoord;\n        varying vec2 v_TexCoord;\n        void main()\n        {\n            v_TexCoord = TexCoord;\n            gl_Position = (MVPMatrix * Position);\n        }        ",fragment:"        #ifdef GL_ES\n        precision mediump float;\n        #endif\n        uniform sampler2D Texture;\n        uniform float Opacity;\n        varying vec2 v_TexCoord;\n        void main()\n        {\n            vec4 texColor = texture2D(Texture, v_TexCoord);\n            gl_FragColor = vec4(Opacity) * texColor;\n        }        "};KNWebGLShader.iris={attribNames:["Position","TexCoord"],uniformNames:["PercentForAlpha","Scale","Mix","Texture","MVPMatrix","Opacity"],vertex:"        #ifdef GL_ES\n        precision highp float;\n        #endif\n        uniform mat4    MVPMatrix;\n        attribute vec4  Position;\n        attribute vec2  TexCoord;\n        varying vec2 v_TexCoord;\n        void main()\n        {\n            v_TexCoord = TexCoord;\n            gl_Position = MVPMatrix * Position;\n        }        ",fragment:"        #ifdef GL_ES\n            precision mediump float;\n        #endif\n        uniform sampler2D Texture;\n        uniform float Opacity;\n        uniform float PercentForAlpha;\n        uniform float Scale;\n        uniform float Mix;\n        varying vec2 v_TexCoord;\n        void main()\n        {\n            vec4 incomingTexColor = texture2D(Texture, v_TexCoord);\n            vec4 clear = vec4(0.0, 0.0, 0.0, 0.0);\n            float tolerance = PercentForAlpha/5.0;\n            vec2 powers = vec2((v_TexCoord.x - 0.5) * Scale,v_TexCoord.y - 0.5);\n            powers *= powers;\n            float radiusSqrd = PercentForAlpha * PercentForAlpha;\n            float dist =  (powers.x+powers.y)/((0.5*Scale)*(0.5*Scale)+0.25);\n            float gradient = smoothstep(radiusSqrd, radiusSqrd+tolerance, dist);\n            gl_FragColor = vec4(Opacity) * mix(clear, incomingTexColor, abs(Mix - gradient));\n        }        "};KNWebGLShader.twist={attribNames:["Position","TexCoord","Normal"],uniformNames:["TextureMatrix","SpecularColor","FlipNormals","MVPMatrix","Texture"],vertex:"        #ifdef GL_ES\n            precision highp float;\n        #endif\n        uniform mat4 MVPMatrix;\n        uniform mat3 TextureMatrix;\n        uniform float SpecularColor;\n        uniform mediump float FlipNormals;\n        attribute vec3 Position;\n        attribute vec3 Normal;\n        attribute vec2 TexCoord;\n        varying vec2 v_TexCoord;\n        varying vec3 v_DiffuseColor;\n        varying vec3 v_SpecularColor;\n        const vec3 c_AmbientColor = vec3(0.2);\n        const vec3 c_DiffuseColor = vec3(1);\n        const float c_LightExponent = 32.0;\n        const vec3 c_LightDirection = vec3(0.1580, +0.5925, 0.7900);\n        const vec3 c_LightHalfPlane = vec3(0.0835, +0.3131, 0.9460);\n        void main()\n        {\n            vec3 thisNormal = Normal * FlipNormals;\n            // Lighting\n            float ndotl = max(0.0, dot(thisNormal, c_LightDirection));\n            float ndoth = max(0.0, dot(thisNormal, c_LightHalfPlane));\n            v_DiffuseColor = (c_AmbientColor + ndotl * c_DiffuseColor);\n            v_SpecularColor = (ndoth <= 0.0) ? vec3(0) : (pow(ndoth, c_LightExponent) * vec3(SpecularColor));\n            gl_Position = MVPMatrix * vec4(Position, 1.0);\n            v_TexCoord = (TextureMatrix * vec3(TexCoord,1.0)).xy;\n        }        ",fragment:"        #ifdef GL_ES\n            precision mediump float;\n        #endif\n        uniform sampler2D Texture;\n        varying vec2 v_TexCoord;\n        varying vec3 v_DiffuseColor;\n        varying vec3 v_SpecularColor;\n        void main()\n        {\n            vec4 texColor = texture2D(Texture, v_TexCoord);\n            // Lighting\n            texColor.xyz = texColor.xyz * v_DiffuseColor + v_SpecularColor;\n            gl_FragColor = texColor;\n        }        "};KNWebGLShader.colorPlanes={attribNames:["Position","TexCoord"],uniformNames:["MVPMatrix","FlipTexCoords","Texture","ColorMask"],vertex:"        #ifdef GL_ES\n            precision highp float;\n        #endif\n        uniform mat4 MVPMatrix;\n        uniform vec2 FlipTexCoords;\n        attribute vec2 Position;\n        attribute vec2 TexCoord;\n        varying vec2 v_TexCoord;\n        void main()\n        {\n            v_TexCoord = vec2(FlipTexCoords.x == 0.0 ? TexCoord.x : 1.0-TexCoord.x, FlipTexCoords.y == 0.0 ? TexCoord.y : 1.0-TexCoord.y);\n            gl_Position = MVPMatrix * vec4(Position, 0,1);\n        }        ",fragment:"        #ifdef GL_ES\n            precision mediump float;\n        #endif\n        uniform sampler2D Texture;\n        uniform vec4 ColorMask;\n        varying vec2 v_TexCoord;\n        void main()\n        {\n            vec4 texColor = texture2D(Texture, v_TexCoord);\n            texColor *= ColorMask;\n            gl_FragColor = texColor;\n        }        "};KNWebGLShader.flop={attribNames:["Position","TexCoord","Normal"],uniformNames:["TextureMatrix","FlipNormals","MVPMatrix","Texture"],vertex:"        \n        #ifdef GL_ES\n        precision highp float;\n        #endif\n        \n        uniform mat4 MVPMatrix;\n        uniform mat3 TextureMatrix;\n        uniform float FlipNormals;\n        \n        attribute vec3 Position;\n        attribute vec3 Normal;\n        attribute vec2 TexCoord;\n        \n        varying vec2 v_TexCoord;\n        varying vec3 v_DiffuseColor;\n        \n        const vec3 c_AmbientColor = vec3(0.1);\n        const vec3 c_DiffuseColor = vec3(1);\n        const float c_LightExponent = 32.0;\n        \n        const vec3 c_LightDirection = vec3(0.000, +0.000, 0.900);\n        \n        void main()\n        {\n            vec3 thisNormal = Normal * FlipNormals;\n            \n            // Lighting\n            vec3 lightDirection = vec3(c_LightDirection.x,c_LightDirection.y,c_LightDirection.z);\n            \n            float ndotl = max(0.0, dot(thisNormal, lightDirection));\n            \n            v_DiffuseColor = (c_AmbientColor + ndotl * c_DiffuseColor);\n            \n            gl_Position = MVPMatrix * vec4(Position, 1);\n            v_TexCoord = (TextureMatrix * vec3(TexCoord,1)).xy;\n        }        ",fragment:"        \n        #ifdef GL_ES\n        precision mediump float;\n        #endif\n        \n        uniform sampler2D Texture;\n        \n        varying vec2 v_TexCoord;\n        varying vec3 v_DiffuseColor;\n        \n        void main()\n        {\n            vec4 texColor = texture2D(Texture, v_TexCoord);\n            \n            // Lighting\n            texColor.xyz = texColor.xyz * v_DiffuseColor;\n            gl_FragColor = texColor;\n        }        "};KNWebGLShader.anvilsmoke={attribNames:["Rotation","Speed","Scale","LifeSpan","ParticleTexCoord","Center","Position"],uniformNames:["Percent","Opacity","ParticleTexture","MVPMatrix"],vertex:"        \n        uniform mat4    MVPMatrix;\n        uniform float   Percent;\n        uniform float   Opacity;\n        \n        attribute vec2  Position;\n        attribute vec2  Center;\n        attribute vec2  ParticleTexCoord;\n        attribute vec3  Rotation;\n        attribute vec3  Speed;\n        attribute float Scale;\n        attribute vec2  LifeSpan;\n        \n        varying vec4    v_Color;\n        varying vec2    v_TexCoord;\n        \n        const float Pi = 3.1415926;\n        const float Pi_2 = 1.5707963;\n        const float TwoPi = 6.2831852;\n        \n        const float sineConstB = 1.2732396; /* = 4./Pi; */\n        const float sineConstC = -0.40528476; /* = -4./(Pi*Pi); */\n        \n        vec3 fastSine(vec3 angle)\n        {\n            vec3 theAngle = mod(angle + Pi, TwoPi) - Pi;\n            return sineConstB * theAngle + sineConstC * theAngle * abs(theAngle);\n        }\n        \n        mat3 fastRotationMatrix(vec3 theRotation)\n        {\n            vec3 sinXYZ = fastSine(theRotation);\n            vec3 cosXYZ = fastSine(Pi_2 - theRotation);\n            mat3 rotMatrix = mat3( cosXYZ.y*cosXYZ.z,  sinXYZ.x*sinXYZ.y*cosXYZ.z+cosXYZ.x*sinXYZ.z, -cosXYZ.x*sinXYZ.y*cosXYZ.z+sinXYZ.x*sinXYZ.z,\n                -cosXYZ.y*sinXYZ.z, -sinXYZ.x*sinXYZ.y*sinXYZ.z+cosXYZ.x*cosXYZ.z,  cosXYZ.x*sinXYZ.y*sinXYZ.z+sinXYZ.x*cosXYZ.z,\n                sinXYZ.y, -sinXYZ.x*cosXYZ.y, cosXYZ.x*cosXYZ.y);\n            return rotMatrix;\n        }\n        \n        void main()\n        {\n            float realPercent = (Percent-LifeSpan.x)/LifeSpan.y;\n                 realPercent = clamp(realPercent, 0.0, 1.0);\n            realPercent = sqrt(realPercent);\n            \n            /* SCALE */\n            vec4 originalPosition = vec4(Position,0,1);\n            vec4 center = vec4(Center, 0,1);\n            vec3 scaleDirectionVec = vec3(originalPosition.xy-center.xy,0) * Scale * mix(0.1, 1.0, realPercent);\n            \n            /* ROTATE */\n            mat3 rotMatrix = fastRotationMatrix(Rotation * realPercent);\n            vec3 rotatedVec = rotMatrix * scaleDirectionVec;\n            vec4 position = center + vec4(rotatedVec,0);\n            \n            float speedAdjust = realPercent;\n            vec3 thisSpeed = Speed;\n            thisSpeed.x *= sqrt(realPercent);\n            thisSpeed.y *= realPercent*realPercent;\n            position += vec4(thisSpeed, 0);\n            \n            float thisOpacity = Opacity;\n            thisOpacity *= (1.0 - realPercent); /* fade out gradually */\n            thisOpacity *= min(1.0, realPercent*20.0);  /* fade in quickly */\n            \n            /* output */\n            gl_Position = MVPMatrix * position;\n            //v_Color = vec4(1.0, 1.0, 1.0, thisOpacity); //we applied a fix here, might not work everywhere\n            v_Color = vec4(thisOpacity);\n            v_TexCoord = ParticleTexCoord;\n        }\n        ",fragment:"        \n        #ifdef GL_ES\n            precision mediump float;\n        #endif\n        uniform sampler2D ParticleTexture;\n        \n        varying vec4 v_Color;\n        varying vec2 v_TexCoord;\n        \n        void main()\n        {\n            vec4 texColor = texture2D(ParticleTexture, v_TexCoord);\n            //if(texColor.w == 0.0)\n            //texColor = vec4(0.0);\n            \n            texColor *= v_Color;\n            \n            gl_FragColor = texColor;\n            //gl_FragColor = vec4(1.0, 0.0, 0.0, 0.5);\n        }\n        "};KNWebGLShader.anvilspeck={attribNames:["Speed","Scale","LifeSpan","ParticleTexCoord","Center","Position"],uniformNames:["Percent","Opacity","ParticleTexture","MVPMatrix"],vertex:"        \n        uniform mat4    MVPMatrix;\n        uniform float   Percent;\n        uniform float   Opacity;\n        \n        attribute vec2  Position;\n        attribute vec2  Center;\n        attribute vec2  ParticleTexCoord;\n        attribute vec3  Speed;\n        attribute float Scale;\n        attribute vec2  LifeSpan;\n        \n        varying vec4    v_Color;\n        varying vec2    v_TexCoord;\n        \n        const float Pi = 3.1415926;\n        const float Pi_2 = 1.5707963;\n        const float TwoPi = 6.2831852;\n        \n        const float sineConstB = 1.2732396; /* = 4./Pi; */\n        const float sineConstC = -0.40528476; /* = -4./(Pi*Pi); */\n        \n        vec3 fastSine(vec3 angle)\n        {\n            vec3 theAngle = mod(angle + Pi, TwoPi) - Pi;\n            return sineConstB * theAngle + sineConstC * theAngle * abs(theAngle);\n        }\n        \n        void main()\n        {\n            float realPercent = (Percent-LifeSpan.x)/LifeSpan.y;\n            realPercent = clamp(realPercent, 0.0, 1.0);\n            \n            /* SCALE */\n            vec4 originalPosition = vec4(Position,0,1);\n            vec4 center = vec4(Center, 0,1);\n            vec3 thisScale = Scale * vec3(1, Speed.z, 1) * mix(0.1, 1.0, realPercent);\n            vec3 scaleDirectionVec = vec3(originalPosition.xy-center.xy,0) * thisScale;\n            \n            vec4 position = center + vec4(scaleDirectionVec,0);\n            \n            float speedAdjust = realPercent;\n            vec3 thisPos = vec3(Speed.x * realPercent,\n                Speed.y * fastSine(Pi*0.85*vec3(realPercent,0,0)).x, /* arc with gravity */\n                0);\n            position += vec4(thisPos, 0);\n            \n            float thisOpacity = Opacity;\n            thisOpacity *= (1.0 - realPercent); /* fade out gradually */\n            thisOpacity *= min(1.0, realPercent*20.0);  /* fade in quickly */\n            \n            /* output */\n            gl_Position = MVPMatrix * position;\n            v_Color = vec4(thisOpacity);\n            v_TexCoord = ParticleTexCoord;\n        }        ",fragment:"        \n        #ifdef GL_ES\n            precision mediump float;\n        #endif\n        uniform sampler2D ParticleTexture;\n        \n        varying vec4 v_Color;\n        varying vec2 v_TexCoord;\n        \n        void main()\n        {\n            vec4 texColor = texture2D(ParticleTexture, v_TexCoord);\n            \n            texColor *= v_Color;\n            \n            gl_FragColor = texColor;\n        }        "};