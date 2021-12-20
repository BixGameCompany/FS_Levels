// idea from https://twitter.com/akivaw/status/1226681850564956160
// blog post https://unitycoder.com/blog/2020/03/01/waves-shader/

Shader "UnityLibrary/Mesh/DriftingWaves"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FoamTex ("Foam", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _MetallicGlossMap("Metallic Gloss Map", 2D) = "white" {}
        _Emission("Emission", float) = 1

        _Radius("Radius", float) = 1
        _PeakSoftener("PeakSoftener", float) = 0.5
        _FresnelPower("FresnelPower", float) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Back

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _FoamTex;
        sampler2D _MetallicGlossMap;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float _Radius;
        float _DriftSpeed;
        float _PeakSoftener;
        float _FresnelPower;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert(inout appdata_full v, out Input o) 
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);

            float offsetX = v.vertex.z * _PeakSoftener;
            v.vertex.z += cos(_Time.y + offsetX) * _Radius;
            v.vertex.y += sin(_Time.y + offsetX) * _Radius;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
            //fixed4 cSpec = tex2D(_MetallicGlossMap, IN.uv_MainTex);

            // testing effects..
            float fresnel = pow(  abs(1 - dot(IN.viewDir, float3(0, 0, 1) )), _FresnelPower );
            //o.Metallic = cSpec.r *_Metallic;
            o.Smoothness = _Glossiness +fresnel;
            o.Alpha = c.a;
        }
        ENDCG

        // different effect for underwater
        Cull Front
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _FoamTex;
        sampler2D _MetallicGlossMap;

        struct Input
        {
            float2 uv_MainTex;
        };
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float _Radius;
        float _DriftSpeed;
        float _PeakSoftener;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            float offsetX = v.vertex.z * _PeakSoftener;
            //v.vertex.z += cos(_Time.y + offsetX) * _Radius;
            //v.vertex.y += sin(_Time.y + offsetX) * _Radius;
            //v.vertex.z -= _Time.y + _DriftSpeed;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color*0.25;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
            fixed4 cSpec = tex2D(_MetallicGlossMap, IN.uv_MainTex);
            //o.Metallic = cSpec.r * _Metallic;
            o.Smoothness = _Glossiness*2;
            o.Alpha = c.a;
            
            //o.Emission = c.rgb * tex2D(_MainTex, IN.uv_MainTex).a * _EmissionColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}