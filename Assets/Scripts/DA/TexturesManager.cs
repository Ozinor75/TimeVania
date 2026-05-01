using System.Collections.Generic;
using UnityEngine;

public class TexturesManager : MonoBehaviour
{
    public List<Material> materials = new List<Material>();
    private GlobalTime globalTime;
    
    void Start()
    {
        globalTime = GetComponent<GlobalTime>();
    }

    public void ChangeMaterialSpeed()
    {
        foreach (Material Imat in materials)
        {
            Imat.SetFloat("_TimeScale", globalTime.active);
        }
    }
}
