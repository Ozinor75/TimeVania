using System;
using System.Linq;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class SpeedOverlay : MonoBehaviour
{
    public GlobalTime globalTime;
    public Material overlay;
    public Material[] materials;
    public Color speedColor;
    public Color baseColor;
    public Color slowColor;

    private void Start()
    {
        globalTime = FindFirstObjectByType<GlobalTime>();
        SetToMid();
    }

    public void SetToSlow()
    {
        overlay.SetColor("_BaseColor", slowColor);
        overlay.SetFloat("_Speed", globalTime.active);

        foreach (Material mat in materials)
            mat.SetFloat("_Speed", globalTime.active);
    }

    public void SetToMid()
    {
        overlay.SetColor("_BaseColor", baseColor);
        overlay.SetFloat("_Speed", globalTime.active);
        
        foreach (Material mat in materials)
            mat.SetFloat("_Speed", globalTime.active);
    }

    public void SetToSpeed()
    {
        overlay.SetColor("_BaseColor", speedColor);
        overlay.SetFloat("_Speed", globalTime.active);
        
        foreach (Material mat in materials)
            mat.SetFloat("_Speed", globalTime.active);
    }
}
