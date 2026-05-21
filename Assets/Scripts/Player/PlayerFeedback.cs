using UnityEngine;
using UnityEngine.Events;

public class PlayerFeedback : MonoBehaviour
{
    [Header("Events")]
    public UnityEvent landing;
    public UnityEvent takeDamage;
    public UnityEvent pushback;
    public UnityEvent powerUp;
    public UnityEvent amelio;

    public void InvokeEvent(UnityEvent e)
    {
        e.Invoke();
    }
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
