using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class OverlayScript : MonoBehaviour
{
    private Material mat;
    public Color baseColor;
    public Color speedColor;
    public Color slowColor;
    
    void Start()
    {
        mat = GetComponent<Image>().material;
        SetBase();
    }


    public void SetSpeed()
    {
        mat.SetColor("_BaseColor", speedColor);
    }
    
    public void SetSlow()
    {
        mat.SetColor("_BaseColor", slowColor);
    }
    
    public void SetBase()
    {
        mat.SetColor("_BaseColor", baseColor);
    }
}
