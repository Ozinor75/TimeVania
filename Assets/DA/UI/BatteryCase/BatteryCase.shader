// Upgrade NOTE: upgraded instancing buffer 'BatteryCase' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BatteryCase"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

        _ExtBody("ExtBody", 2D) = "white" {}
        _IntBody("IntBody", 2D) = "white" {}
        _ExtCap("ExtCap", 2D) = "white" {}
        _CloseCap("CloseCap", 2D) = "white" {}
        _CloseCap1("CloseCap", 2D) = "white" {}
        _IsBackground("IsBackground", Range( 0 , 1)) = 0
        _StartCloseCap("StartCloseCap", 2D) = "white" {}
        _BaseColor("BaseColor", Color) = (0.2225868,0.1468494,0.4150943,1)
        _ActiveLevel("ActiveLevel", Float) = 2

    }

    SubShader
    {
		LOD 0

        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

        Stencil
        {
        	Ref [_Stencil]
        	ReadMask [_StencilReadMask]
        	WriteMask [_StencilWriteMask]
        	Comp [_StencilComp]
        	Pass [_StencilOp]
        }


        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend One OneMinusSrcAlpha
        ColorMask [_ColorMask]

        
        Pass
        {
            Name "Default"
        CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            #pragma multi_compile_instancing


            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                float4  mask : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
                
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;

            uniform float _IsBackground;
            uniform sampler2D _IntBody;
            uniform sampler2D _ExtBody;
            uniform sampler2D _ExtCap;
            uniform sampler2D _CloseCap;
            uniform sampler2D _CloseCap1;
            uniform sampler2D _StartCloseCap;
            UNITY_INSTANCING_BUFFER_START(BatteryCase)
            	UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
#define _BaseColor_arr BatteryCase
            	UNITY_DEFINE_INSTANCED_PROP(float, _ActiveLevel)
#define _ActiveLevel_arr BatteryCase
            UNITY_INSTANCING_BUFFER_END(BatteryCase)

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                

                v.vertex.xyz +=  float3( 0, 0, 0 ) ;

                float4 vPosition = UnityObjectToClipPos(v.vertex);
                OUT.worldPosition = v.vertex;
                OUT.vertex = vPosition;

                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                OUT.texcoord = v.texcoord;
                OUT.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN ) : SV_Target
            {
                //Round up the alpha color coming from the interpolator (to 1.0/256.0 steps)
                //The incoming alpha could have numerical instability, which makes it very sensible to
                //HDR color transparency blend, when it blends with the world's texture.
                const half alphaPrecision = half(0xff);
                const half invAlphaPrecision = half(1.0/alphaPrecision);
                IN.color.a = round(IN.color.a * alphaPrecision)*invAlphaPrecision;

                float2 texCoord118 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float2 texCoord83 = IN.texcoord.xy * float2( 1,1 ) + float2( -0.01,0 );
                float2 appendResult10_g10 = (float2(0.69 , 1.0));
                float2 temp_output_11_0_g10 = ( abs( (texCoord83*2.0 + -1.0) ) - appendResult10_g10 );
                float2 break16_g10 = ( 1.0 - ( temp_output_11_0_g10 / fwidth( temp_output_11_0_g10 ) ) );
                float _ActiveLevel_Instance = UNITY_ACCESS_INSTANCED_PROP(_ActiveLevel_arr, _ActiveLevel);
                float temp_output_74_0 = ( 0.062 * ( _ActiveLevel_Instance * 2.0 ) );
                float2 appendResult113 = (float2(( temp_output_74_0 + 0.2 ) , 0.0));
                float2 appendResult1 = (float2(appendResult113));
                float2 texCoord2 = IN.texcoord.xy * float2( -1,1 ) + appendResult1;
                float2 appendResult10_g11 = (float2(1.0 , 1.0));
                float2 temp_output_11_0_g11 = ( abs( (texCoord2*2.0 + -1.0) ) - appendResult10_g11 );
                float2 break16_g11 = ( 1.0 - ( temp_output_11_0_g11 / fwidth( temp_output_11_0_g11 ) ) );
                float temp_output_92_0 = ( saturate( min( break16_g10.x , break16_g10.y ) ) - ( 1.0 - saturate( min( break16_g11.x , break16_g11.y ) ) ) );
                float4 _BaseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseColor_arr, _BaseColor);
                float2 texCoord3 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float2 texCoord58 = IN.texcoord.xy * float2( 1,1 ) + float2( 0.31,0 );
                float2 appendResult55 = (float2(( ( temp_output_74_0 + 0.31 ) + 0.379 ) , 0.0));
                float2 texCoord50 = IN.texcoord.xy * float2( -1,1 ) + appendResult55;
                float4 blendOpSrc101 = ( temp_output_92_0 * tex2D( _ExtBody, texCoord3 ) );
                float4 blendOpDest101 = ( tex2D( _ExtCap, texCoord58 ) + tex2D( _CloseCap, texCoord50 ) );
                float4 blendOpSrc102 = ( saturate( ( blendOpSrc101 + blendOpDest101 ) ));
                float4 blendOpDest102 = ( tex2D( _CloseCap1, texCoord50 ) + tex2D( _StartCloseCap, texCoord58 ) );
                

                half4 color = ( _IsBackground == 1.0 ? ( ( tex2D( _IntBody, texCoord118 ) * temp_output_92_0 ) * _BaseColor_Instance ) : ( _BaseColor_Instance * ( saturate( ( blendOpSrc102 + blendOpDest102 ) )) ) );

                #ifdef UNITY_UI_CLIP_RECT
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                color.a *= m.x * m.y;
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                color.rgb *= color.a;

                return color;
            }
        ENDCG
        }
    }
    CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.SamplerNode;23;-821.1734,135.8179;Inherit;True;Property;_ExtCap;ExtCap;2;0;Create;True;0;0;0;False;0;False;-1;4ba35876c2cab6345b8d3f1056913810;ac5d2e33c90b4a04bbda6378c9bc638f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;-820.2379,355.7959;Inherit;True;Property;_CloseCap;CloseCap;3;0;Create;True;0;0;0;False;0;False;-1;4ba35876c2cab6345b8d3f1056913810;ac5d2e33c90b4a04bbda6378c9bc638f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-839.2258,608.952;Inherit;True;Property;_CloseCap1;CloseCap;4;0;Create;True;0;0;0;False;0;False;-1;4ba35876c2cab6345b8d3f1056913810;ff973625bc9fddf46980f8b476dc7965;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;-835.9293,821.7782;Inherit;True;Property;_StartCloseCap;StartCloseCap;6;0;Create;True;0;0;0;False;0;False;-1;4ba35876c2cab6345b8d3f1056913810;ff973625bc9fddf46980f8b476dc7965;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-1134.308,39.36463;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.31,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;4;-751.7856,-388.1618;Inherit;True;Rectangle;-1;;10;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.69;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1;-1251.047,-568.5756;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-68.89859,101.7461;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-69.26889,327.9918;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-2171.073,123.4239;Inherit;False;2;2;0;FLOAT;0.062;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1989.432,179.7773;Inherit;False;2;2;0;FLOAT;0.062;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-1720.328,365.077;Inherit;False;2;2;0;FLOAT;0.45;False;1;FLOAT;0.379;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;84;-781.9852,-619.4773;Inherit;False;Rectangle;-1;;11;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;112;-561.6801,-593.656;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-1230.349,355.5039;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1081.937,-617.3278;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;55;-1587.029,304.6303;Inherit;False;FLOAT2;4;0;FLOAT;0.31;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-1519.858,48.55772;Inherit;False;FLOAT2;4;0;FLOAT;0.31;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-1842.328,283.077;Inherit;False;2;2;0;FLOAT;0.45;False;1;FLOAT;0.31;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;116;-1785.828,71.58259;Inherit;False;2;2;0;FLOAT;0.45;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-1084.985,-407.4773;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.01,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1083.751,-143.5095;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-824.334,-158.2992;Inherit;True;Property;_ExtBody;ExtBody;0;0;Create;True;0;0;0;False;0;False;-1;4ba35876c2cab6345b8d3f1056913810;8d3f5936d202d524eb662d9e65d77f7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-67.84569,-127.4263;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;101;251.233,-126.9113;Inherit;True;LinearDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;102;531.8332,163.1887;Inherit;True;LinearDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;847.186,-114.6176;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;92;-302.0701,-407.11;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;118;-105.6426,-1145.747;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;119;126.3598,-1123.414;Inherit;True;Property;_IntBody;IntBody;1;0;Create;True;0;0;0;False;0;False;-1;4ba35876c2cab6345b8d3f1056913810;98204bf76b687754d8718d9a3946658f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;492.616,-972.7064;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;835.8024,-236.6633;Inherit;False;Property;_IsBackground;IsBackground;5;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;914.4163,-547.3838;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1985.815,-77.52825;Float;False;True;-1;2;ASEMaterialInspector;0;3;BatteryCase;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.Compare;18;1703.47,-107.4598;Inherit;True;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2430.336,120.0432;Inherit;False;InstancedProperty;_ActiveLevel;ActiveLevel;8;0;Create;True;0;0;0;False;0;False;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;477.5313,-326.4653;Inherit;False;InstancedProperty;_BaseColor;BaseColor;7;0;Create;True;0;0;0;False;0;False;0.2225868,0.1468494,0.4150943,1;0.1465014,0.1034621,0.2924528,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;23;1;58;0
WireConnection;31;1;50;0
WireConnection;41;1;50;0
WireConnection;46;1;58;0
WireConnection;4;1;83;0
WireConnection;1;0;113;0
WireConnection;37;0;23;0
WireConnection;37;1;31;0
WireConnection;49;0;41;0
WireConnection;49;1;46;0
WireConnection;79;0;12;0
WireConnection;74;1;79;0
WireConnection;82;0;78;0
WireConnection;84;1;2;0
WireConnection;112;0;84;0
WireConnection;50;1;55;0
WireConnection;2;1;1;0
WireConnection;55;0;82;0
WireConnection;113;0;116;0
WireConnection;78;0;74;0
WireConnection;116;0;74;0
WireConnection;5;1;3;0
WireConnection;22;0;92;0
WireConnection;22;1;5;0
WireConnection;101;0;22;0
WireConnection;101;1;37;0
WireConnection;102;0;101;0
WireConnection;102;1;49;0
WireConnection;95;0;8;0
WireConnection;95;1;102;0
WireConnection;92;0;4;0
WireConnection;92;1;112;0
WireConnection;119;1;118;0
WireConnection;120;0;119;0
WireConnection;120;1;92;0
WireConnection;117;0;120;0
WireConnection;117;1;8;0
WireConnection;0;0;18;0
WireConnection;18;0;19;0
WireConnection;18;2;117;0
WireConnection;18;3;95;0
ASEEND*/
//CHKSM=02E3F483AC2F5B04E7653B1A99246B0FF96EDB18