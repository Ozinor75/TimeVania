using TMPro;
using UnityEngine;
using TMPro;

public class PlayerTimer : MonoBehaviour
{
    public float timer;
    public float t;
    public float tMult;
    public TextMeshProUGUI text;
    
    void Start()
    {
        t = timer;
    }
    
    void Update()
    {
        t -= Time.deltaTime * tMult;
        text.text = t.ToString("0.00");
        
        if (t <= 0f)
        {
            Debug.Log("OUTTA TIME !!!");
        }
    }
}
